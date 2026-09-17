using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditProgrammeModule
{
    public class AuditProgrammeService : IAuditProgrammeService
    {
        private readonly IAuditProgrammeRepository _repository;

        public AuditProgrammeService(IAuditProgrammeRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SaveAuditProgrammeAsync(AuditProgrammeDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) return false;

            var errors = await GetConflictValidationsAsync(dto, cancellationToken);
            if (errors.Any())
                throw new InvalidOperationException(string.Join(" ", errors));

            await SaveOrUpdateAsync(dto, cancellationToken);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
             where TEntity : Entity<TId>
        {
            if (dto is not AuditProgrammeDto pDto)
                throw new InvalidOperationException("Invalid DTO type.");

            var entity = pDto.ToEntity();
            var dbContext = _repository.GetDbContext();

            if (entity.Id == 0)
            {
                // BRAND NEW AUDIT PROGRAMME — always starts as Draft, stated
                // explicitly here regardless of the domain's own default, so
                // it can't drift silently if that default ever changes.
                entity.AuditStatusId = AuditStatusSeedIds.Draft;
                entity.CreatedDate = DateTime.UtcNow;

                dbContext.Add(entity);
                await dbContext.SaveChangesAsync(cancellationToken);

                // FIX: ToEntity() builds a separate object graph, so the caller's
                // dto never saw the generated id — the POST endpoint echoes this
                // same dto back, so without this the client always got id=0.
                pDto.Id = entity.Id;

                dbContext.Set<AuditProgrammeStatusHistory>().Add(new AuditProgrammeStatusHistory
                {
                    Id = 0,
                    AuditProgrammeId = entity.Id,
                    AuditStatusId = entity.AuditStatusId
                });
                await dbContext.SaveChangesAsync(cancellationToken);
            }
            else
            {
                // EXISTING AUDIT PROGRAMME UPDATE
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken);
                if (existing == null) throw new KeyNotFoundException("Audit Programme not found.");

                // FIX: preserve status — SetValues would otherwise overwrite the
                // real status with the DTO's default (Draft), silently reverting
                // an Approved/Disapproved programme back to Draft on every edit.
                // Status only ever changes through SubmitAsync/DecideAsync.
                var preservedStatusId = existing.AuditStatusId;

                // Update root primitive fields (including Sections IV to IX)
                dbContext.Entry(existing).CurrentValues.SetValues(entity);
                existing.AuditStatusId = preservedStatusId;
                existing.LastModifiedDate = DateTime.UtcNow;

                // --- Sync Objectives Collection ---
                if (existing.Objectives?.Any() == true)
                {
                    _repository.RemoveObjectives(existing.Objectives.ToList());
                }
                existing.Objectives = entity.Objectives;

                // --- Sync Audit Plans & Deep Sub-Collections Safely ---
                await UpdateAuditPlansAsync(dbContext, existing, entity, cancellationToken);

                // Save changes via pipeline commit
                await dbContext.SaveChangesAsync(cancellationToken);
            }
        }

        private async Task UpdateAuditPlansAsync(DbContext dbContext, AuditProgramme existing, AuditProgramme incoming, CancellationToken cancellationToken)
        {
            existing.AuditPlans ??= new List<AuditPlan>();
            incoming.AuditPlans ??= new List<AuditPlan>();

            var plansToRemove = existing.AuditPlans
                .Where(ep => !incoming.AuditPlans.Any(ip => ip.Id == ep.Id && ep.Id != 0)).ToList();

            foreach (var plan in plansToRemove)
            {
                existing.AuditPlans.Remove(plan);
                await RemovePlanWithChildrenAsync(dbContext, plan, cancellationToken);
            }

            foreach (var incomingPlan in incoming.AuditPlans)
            {
                var existingPlan = existing.AuditPlans.FirstOrDefault(ep => ep.Id == incomingPlan.Id && ep.Id != 0);

                if (existingPlan == null)
                {
                    incomingPlan.AuditProgrammeId = existing.Id;
                    existing.AuditPlans.Add(incomingPlan);
                }
                else
                {
                    // Preserve status — SetValues would otherwise overwrite the plan's
                    // real AuditStatusId with incomingPlan's value (the client never
                    // sends a plan status), silently reverting the plan's status on
                    // every programme edit. Mirrors the same protection already applied
                    // to AuditProgramme.AuditStatusId in SaveOrUpdateAsync above.
                    var preservedPlanStatusId = existingPlan.AuditStatusId;
                    dbContext.Entry(existingPlan).CurrentValues.SetValues(incomingPlan);
                    existingPlan.AuditStatusId = preservedPlanStatusId;

                    await SyncAuditPlanEntriesAsync(dbContext, existingPlan, incomingPlan, cancellationToken);
                }
            }
        }

        private async Task SyncAuditPlanEntriesAsync(DbContext dbContext, AuditPlan existingPlan, AuditPlan incomingPlan, CancellationToken cancellationToken)
        {
            existingPlan.Entries ??= new List<AuditPlanEntry>();
            incomingPlan.Entries ??= new List<AuditPlanEntry>();

            var entriesToRemove = existingPlan.Entries
                .Where(ee => !incomingPlan.Entries.Any(ie => ie.Id == ee.Id && ee.Id != 0)).ToList();

            foreach (var entry in entriesToRemove)
            {
                existingPlan.Entries.Remove(entry);
                await RemoveEntryWithChildrenAsync(dbContext, entry, cancellationToken);
            }

            foreach (var incomingEntry in incomingPlan.Entries)
            {
                var existingEntry = existingPlan.Entries.FirstOrDefault(ee => ee.Id == incomingEntry.Id && ee.Id != 0);

                if (existingEntry == null)
                {
                    incomingEntry.AuditPlanId = existingPlan.Id;
                    existingPlan.Entries.Add(incomingEntry);
                }
                else
                {
                    dbContext.Entry(existingEntry).CurrentValues.SetValues(incomingEntry);
                    SyncEntryGrandchildCollections(dbContext, existingEntry, incomingEntry);
                }
            }
        }

        // The loaded navigation collections can be stale or filtered (e.g.
        // `!IsDeleted`), so trusting them left orphan rows behind that then
        // blocked this entry's own delete with an FK violation. Query every
        // dependent table directly by AuditPlanEntryId so nothing survives.
        private static async Task RemoveEntryWithChildrenAsync(DbContext dbContext, AuditPlanEntry entry, CancellationToken cancellationToken)
        {
            dbContext.Set<IsoStandardAuditPlan>().RemoveRange(
                await dbContext.Set<IsoStandardAuditPlan>().Where(x => x.AuditPlanEntryId == entry.Id).ToListAsync(cancellationToken));
            dbContext.Set<AuditPlanProcess>().RemoveRange(
                await dbContext.Set<AuditPlanProcess>().Where(x => x.AuditPlanEntryId == entry.Id).ToListAsync(cancellationToken));
            dbContext.Set<AuditPlanPersonResponsible>().RemoveRange(
                await dbContext.Set<AuditPlanPersonResponsible>().Where(x => x.AuditPlanEntryId == entry.Id).ToListAsync(cancellationToken));
            dbContext.Set<IsoAuditor>().RemoveRange(
                await dbContext.Set<IsoAuditor>().Where(x => x.AuditPlanEntryId == entry.Id).ToListAsync(cancellationToken));
            dbContext.Set<IsoAuditProcess>().RemoveRange(
                await dbContext.Set<IsoAuditProcess>().Where(x => x.AuditPlanEntryId == entry.Id).ToListAsync(cancellationToken));

            dbContext.Set<AuditPlanEntry>().Remove(entry);
        }

        // Same reasoning one level up: re-query every entry/approval/schedule
        // that still points at this plan instead of trusting what was loaded.
        private static async Task RemovePlanWithChildrenAsync(DbContext dbContext, AuditPlan plan, CancellationToken cancellationToken)
        {
            var entries = await dbContext.Set<AuditPlanEntry>().Where(x => x.AuditPlanId == plan.Id).ToListAsync(cancellationToken);
            foreach (var entry in entries)
                await RemoveEntryWithChildrenAsync(dbContext, entry, cancellationToken);

            dbContext.Set<AuditPlanApproval>().RemoveRange(
                await dbContext.Set<AuditPlanApproval>().Where(x => x.AuditPlanId == plan.Id).ToListAsync(cancellationToken));
            dbContext.Set<AuditSchedule>().RemoveRange(
                await dbContext.Set<AuditSchedule>().Where(x => x.AuditPlanId == plan.Id).ToListAsync(cancellationToken));

            dbContext.Set<AuditPlan>().Remove(plan);
        }

        private void SyncEntryGrandchildCollections(DbContext dbContext, AuditPlanEntry existingEntry, AuditPlanEntry incomingEntry)
        {
            existingEntry.IsoAuditProcesses ??= new List<IsoAuditProcess>();
            incomingEntry.IsoAuditProcesses ??= new List<IsoAuditProcess>();

            existingEntry.ResponsiblePersons ??= new List<AuditPlanPersonResponsible>();
            incomingEntry.ResponsiblePersons ??= new List<AuditPlanPersonResponsible>();

            existingEntry.IsoAuditors ??= new List<IsoAuditor>();
            incomingEntry.IsoAuditors ??= new List<IsoAuditor>();

            existingEntry.IsoStandardAuditPlans ??= new List<IsoStandardAuditPlan>();
            incomingEntry.IsoStandardAuditPlans ??= new List<IsoStandardAuditPlan>();

            existingEntry.AuditPlanProcesses ??= new List<AuditPlanProcess>();
            incomingEntry.AuditPlanProcesses ??= new List<AuditPlanProcess>();

            // 1. IsoAuditProcesses
            var processesToRemove = existingEntry.IsoAuditProcesses.Where(ep => !incomingEntry.IsoAuditProcesses.Any(ip => ip.Id == ep.Id && ep.Id != 0)).ToList();
            foreach (var p in processesToRemove) { existingEntry.IsoAuditProcesses.Remove(p); dbContext.Set<IsoAuditProcess>().Remove(p); }
            foreach (var incomingP in incomingEntry.IsoAuditProcesses)
            {
                var existingP = existingEntry.IsoAuditProcesses.FirstOrDefault(ep => ep.Id == incomingP.Id && ep.Id != 0);
                if (existingP == null) { incomingP.AuditPlanEntryId = existingEntry.Id; existingEntry.IsoAuditProcesses.Add(incomingP); }
                else dbContext.Entry(existingP).CurrentValues.SetValues(incomingP);
            }

            // 2. ResponsiblePersons
            var personsToRemove = existingEntry.ResponsiblePersons.Where(er => !incomingEntry.ResponsiblePersons.Any(ir => ir.Id == er.Id && er.Id != 0)).ToList();
            foreach (var p in personsToRemove) { existingEntry.ResponsiblePersons.Remove(p); dbContext.Set<AuditPlanPersonResponsible>().Remove(p); }
            foreach (var incomingRp in incomingEntry.ResponsiblePersons)
            {
                var existingRp = existingEntry.ResponsiblePersons.FirstOrDefault(er => er.Id == incomingRp.Id && er.Id != 0);
                if (existingRp == null) { incomingRp.AuditPlanEntryId = existingEntry.Id; existingEntry.ResponsiblePersons.Add(incomingRp); }
                else dbContext.Entry(existingRp).CurrentValues.SetValues(incomingRp);
            }

            // 3. IsoAuditors
            var auditorsToRemove = existingEntry.IsoAuditors
                .Where(ea => !incomingEntry.IsoAuditors.Any(ia => ia.Id == ea.Id && ea.Id != 0)).ToList();

            foreach (var a in auditorsToRemove)
            {
                existingEntry.IsoAuditors.Remove(a);
                dbContext.Set<IsoAuditor>().Remove(a);
            }

            foreach (var incomingA in incomingEntry.IsoAuditors)
            {
                incomingA.AuditorId = null;

                var auditorProp = incomingA.GetType().GetProperty("Auditor");
                if (auditorProp != null && auditorProp.CanWrite)
                {
                    auditorProp.SetValue(incomingA, null);
                }

                var existingA = existingEntry.IsoAuditors.FirstOrDefault(ea => ea.Id == incomingA.Id && ea.Id != 0);
                if (existingA == null)
                {
                    incomingA.AuditPlanEntryId = existingEntry.Id;
                    existingEntry.IsoAuditors.Add(incomingA);
                }
                else
                {
                    dbContext.Entry(existingA).CurrentValues.SetValues(incomingA);
                    dbContext.Entry(existingA).Property("AuditorId").IsModified = true;
                }
            }

            // 4. IsoStandardAuditPlans
            var standardsToRemove = existingEntry.IsoStandardAuditPlans.Where(es => !incomingEntry.IsoStandardAuditPlans.Any(isPlan => isPlan.Id == es.Id && es.Id != 0)).ToList();
            foreach (var s in standardsToRemove) { existingEntry.IsoStandardAuditPlans.Remove(s); dbContext.Set<IsoStandardAuditPlan>().Remove(s); }
            foreach (var incomingS in incomingEntry.IsoStandardAuditPlans)
            {
                var existingS = existingEntry.IsoStandardAuditPlans.FirstOrDefault(es => es.Id == incomingS.Id && es.Id != 0);
                if (existingS == null) { incomingS.AuditPlanEntryId = existingEntry.Id; existingEntry.IsoStandardAuditPlans.Add(incomingS); }
                else dbContext.Entry(existingS).CurrentValues.SetValues(incomingS);
            }

            // 5. AuditPlanProcesses
            var appToRemove = existingEntry.AuditPlanProcesses.Where(eap => !incomingEntry.AuditPlanProcesses.Any(iap => iap.Id == eap.Id && eap.Id != 0)).ToList();
            foreach (var ap in appToRemove) { existingEntry.AuditPlanProcesses.Remove(ap); dbContext.Set<AuditPlanProcess>().Remove(ap); }
            foreach (var incomingAp in incomingEntry.AuditPlanProcesses)
            {
                var existingAp = existingEntry.AuditPlanProcesses.FirstOrDefault(eap => eap.Id == incomingAp.Id && eap.Id != 0);
                if (existingAp == null) { incomingAp.AuditPlanEntryId = existingEntry.Id; existingEntry.AuditPlanProcesses.Add(incomingAp); }
                else dbContext.Entry(existingAp).CurrentValues.SetValues(incomingAp);
            }
        }

        public async Task<List<string>> GetConflictValidationsAsync(AuditProgrammeDto dto, CancellationToken cancellationToken)
        {
            var errors = new List<string>();

            if (dto.Year < 2000 || dto.Year > 2100)
                errors.Add("Please provide a valid audit year.");

            if (dto.Objectives == null || !dto.Objectives.Any())
                errors.Add("An audit programme must have at least one objective.");

            return await Task.FromResult(errors);
        }

        public async Task<(bool Success, string? Error)> SubmitAsync(int id, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var entity = await dbContext.Set<AuditProgramme>()
                .Include(x => x.AuditStatus)
                .Include(x => x.Objectives)
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

            if (entity?.AuditStatus == null)
                return (false, "Audit programme not found.");

            var currentCode = entity.AuditStatus.Code;
            if (currentCode != AuditStatusCodes.Draft && currentCode != AuditStatusCodes.Disapproved)
                return (false, $"Cannot submit from status '{currentCode}'.");

            var dto = new AuditProgrammeDto(entity);
            var errors = await GetConflictValidationsAsync(dto, cancellationToken);
            if (errors.Any())
                return (false, string.Join(" ", errors));

            var pending = await dbContext.Set<AuditPlanStatus>()
                .FirstOrDefaultAsync(s => s.Code == AuditStatusCodes.Pending, cancellationToken);
            if (pending == null)
                return (false, "Pending status is not configured.");

            entity.AuditStatusId = pending.Id;
            entity.LastModifiedDate = DateTime.UtcNow;

            dbContext.Set<AuditProgrammeStatusHistory>().Add(new AuditProgrammeStatusHistory
            {
                Id = 0,
                AuditProgrammeId = entity.Id,
                AuditStatusId = pending.Id
            });

            await dbContext.SaveChangesAsync(cancellationToken);
            return (true, null);
        }

        public async Task<(bool Success, string? Error)> DecideAsync(int id, string approverId, bool approve, string? comments, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var entity = await dbContext.Set<AuditProgramme>()
                .Include(x => x.AuditStatus)
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

            if (entity?.AuditStatus == null)
                return (false, "Audit programme not found.");

            if (entity.AuditStatus.Code != AuditStatusCodes.Pending)
                return (false, $"Cannot decide on a programme in status '{entity.AuditStatus.Code}'.");

            var targetCode = approve ? AuditStatusCodes.Approved : AuditStatusCodes.Disapproved;
            var targetStatus = await dbContext.Set<AuditPlanStatus>()
                .FirstOrDefaultAsync(s => s.Code == targetCode, cancellationToken);
            if (targetStatus == null)
                return (false, $"Status '{targetCode}' is not configured.");

            entity.AuditStatusId = targetStatus.Id;
            entity.LastModifiedDate = DateTime.UtcNow;

            dbContext.Set<AuditProgrammeStatusHistory>().Add(new AuditProgrammeStatusHistory
            {
                Id = 0,
                AuditProgrammeId = entity.Id,
                AuditStatusId = targetStatus.Id,
                Remarks = comments
            });

            // Shared AuditPlanApproval table — AuditProgrammeId set,
            // AuditPlanId left null since this decision belongs to a
            // Programme, not a Plan.
            dbContext.Set<AuditPlanApproval>().Add(new AuditPlanApproval
            {
                Id = 0,
                AuditProgrammeId = entity.Id,
                ApproverId = approverId,
                Action = approve ? "Approve" : "Reject",
                Timestamp = DateTime.UtcNow,
                Comments = comments
            });

            await dbContext.SaveChangesAsync(cancellationToken);
            return (true, null);
        }

        public async Task<DtoPageList<AuditProgrammeDto, AuditProgramme, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            // An empty page is a valid answer, not an error — DtoPageList.Create
            // already handles an empty Items collection correctly.
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            return DtoPageList<AuditProgrammeDto, AuditProgramme, int>.Create(result.Items, page, pageSize, result.TotalCount);
        }

        public async Task<AuditProgrammeDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken);
            return entity != null ? new AuditProgrammeDto(entity) : null;
        }

        public async Task<ReportAuditProgrammeDto?> ReportGetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);

            if (entity == null)
            {
                return null;
            }

            var dto = new ReportAuditProgrammeDto
            {
                Id = entity.Id,
                Year = entity.Year,
                For = entity.For ?? string.Empty,
                From = entity.From ?? string.Empty,
                Purpose = entity.Purpose ?? string.Empty,
                ScopeAndFreqAudit = entity.ScopeAndFreqAudit ?? string.Empty,
                InternalAuditSched = entity.InternalAuditSched ?? string.Empty,
                AuditPlanObjective = entity.AuditPlanObjective ?? string.Empty,
                ScopeOfAudit = entity.ScopeOfAudit ?? string.Empty,

                AuditCriteria = entity.AuditCriteria ?? string.Empty,
                AuditMethodology = entity.AuditMethodology ?? string.Empty,
                SelectionAndEvaluationOfAuditors = entity.SelectionAndEvaluationOfAuditors ?? string.Empty,
                Reporting = entity.Reporting ?? string.Empty,
                VerificationOfPreviousNonconformities = entity.VerificationOfPreviousNonconformities ?? string.Empty,
                AuditLimitations = entity.AuditLimitations ?? string.Empty,

                IsDeleted = entity.IsDeleted,
                RowVersion = entity.RowVersion
            };

            dto.Objectives = entity.Objectives?
                .OrderBy(o => o.SortOrder)
                .Select(o => new ReportObjectiveItemDto
                {
                    Id = o.Id,
                    Text = o.Description ?? string.Empty
                })
                .ToList() ?? new List<ReportObjectiveItemDto>();

            if (entity.AuditPlans != null)
            {
                int batchCounter = 1;
                var formattedBatches = new List<ReportAuditPlanBatchDto>();

                foreach (var plan in entity.AuditPlans.OrderBy(p => p.StartDate))
                {
                    var reportBatch = new ReportAuditPlanBatchDto
                    {
                        Id = plan.Id,
                        StartDate = plan.StartDate,
                        EndDate = plan.EndDate,
                        PlanStatus = plan.AuditStatus?.Name ?? "Draft",
                        BatchIndexString = batchCounter.ToString(),
                        BatchFormattedDates = FormatBatchDateRange(plan.StartDate, plan.EndDate),
                        Entries = new List<ReportScheduleEntryDto>()
                    };

                    if (plan.Entries != null)
                    {
                        int maxDay = plan.Entries.Any() ? plan.Entries.Max(e => e.DayNumber) : 1;

                        foreach (var entry in plan.Entries.OrderBy(e => e.DayNumber).ThenBy(e => e.Time))
                        {
                            string officeNamesCombined = "N/A";
                            if (entry.AuditPlanProcesses != null && entry.AuditPlanProcesses.Any())
                            {
                                var officeNames = entry.AuditPlanProcesses
                                    .Select(app =>
                                    {
                                        if (app.Office != null)
                                        {
                                            var currentOffice = app.Office;
                                            var parent = currentOffice.ParentOffice;
                                            string? departmentName = null;
                                            string? serviceName = null;

                                            while (parent != null)
                                            {
                                                if (parent.OfficeTypeId == 2)
                                                {
                                                    departmentName = parent.Name;
                                                    break;
                                                }

                                                if (parent.OfficeTypeId == 1)
                                                {
                                                    serviceName = parent.Name;
                                                }

                                                parent = parent.ParentOffice;
                                            }

                                            if (!string.IsNullOrEmpty(departmentName))
                                            {
                                                return $"{departmentName} - {currentOffice.Name}";
                                            }

                                            if (!string.IsNullOrEmpty(serviceName) && currentOffice.Name != serviceName)
                                            {
                                                return $"{serviceName} - {currentOffice.Name}";
                                            }

                                            return currentOffice.Name;
                                        }

                                        if (!string.IsNullOrWhiteSpace(app.ProcessName))
                                        {
                                            return app.ProcessName!.Trim();
                                        }

                                        return app.OfficeId != null ? $"Office {app.OfficeId}" : $"Process {app.Id}";
                                    })
                                    .Where(name => !string.IsNullOrEmpty(name))
                                    .ToList();

                                if (officeNames.Any())
                                {
                                    officeNamesCombined = string.Join(Environment.NewLine, officeNames);
                                }
                            }
                            else if (entry.IsoAuditProcesses != null && entry.IsoAuditProcesses.Any())
                            {
                                var processNames = entry.IsoAuditProcesses
                                    .Select(p => p.Name)
                                    .Where(name => !string.IsNullOrEmpty(name))
                                    .ToList();

                                if (processNames.Any())
                                {
                                    officeNamesCombined = string.Join(Environment.NewLine, processNames);
                                }
                            }

                            string standardChaptersCombined = "N/A";
                            if (entry.IsoStandardAuditPlans != null && entry.IsoStandardAuditPlans.Any())
                            {
                                var clauses = entry.IsoStandardAuditPlans
                                    .Where(isap => isap.IsoStandard != null && !string.IsNullOrEmpty(isap.IsoStandard.ClauseRef))
                                    .Select(isap => isap.IsoStandard.ClauseRef)
                                    .OrderBy(clause => clause)
                                    .ToList();

                                if (clauses.Any())
                                {
                                    standardChaptersCombined = string.Join(", ", clauses);
                                }
                            }

                            string auditorsLinesCombined = string.Empty;
                            if (entry.IsoAuditors != null && entry.IsoAuditors.Any())
                            {
                                var firstAuditorNode = entry.IsoAuditors.FirstOrDefault();
                                if (firstAuditorNode != null)
                                {
                                    auditorsLinesCombined = firstAuditorNode.Team != null
                                        ? firstAuditorNode.Team.Name
                                        : $"Team {firstAuditorNode.TeamId ?? 1}";
                                }
                            }

                            DateTime calculatedEntryDate = plan.StartDate.AddDays(entry.DayNumber - 1);

                            var scheduleEntry = new ReportScheduleEntryDto
                            {
                                Id = entry.Id,
                                DayNumber = entry.DayNumber,
                                Time = entry.Time,
                                TotalDaysInBatch = maxDay,
                                FormattedOfficeNames = officeNamesCombined.Trim(),
                                FormattedStandardChapters = standardChaptersCombined.Trim(),
                                FormattedProposedSchedule = calculatedEntryDate.ToString("MMMM dd, yyyy"),
                                FormattedAuditorTeamAndMembers = auditorsLinesCombined
                            };

                            reportBatch.Entries.Add(scheduleEntry);
                            dto.FlatEntries.Add(scheduleEntry);
                        }
                    }

                    formattedBatches.Add(reportBatch);
                    batchCounter++;
                }

                dto.AuditPlan = formattedBatches;
            }

            return dto;
        }

        private string FormatBatchDateRange(DateTime start, DateTime end)
        {
            if (start.Date == end.Date)
            {
                return start.ToString("MMMM dd, yyyy");
            }
            if (start.Month == end.Month && start.Year == end.Year)
            {
                return $"{start:MMMM dd} - {end:dd, yyyy}";
            }
            if (start.Year == end.Year)
            {
                return $"{start:MMMM dd} - {end:MMMM dd, yyyy}";
            }
            return $"{start:MMMM dd, yyyy} - {end:MMMM dd, yyyy}";
        }

        public async Task<List<AuditProgrammeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAllAsync(cancellationToken);
            return entities?.Select(e => new AuditProgrammeDto(e)).ToList() ?? new List<AuditProgrammeDto>();
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null) return false;

            if (entity.AuditStatusId != AuditStatusSeedIds.Draft)
                throw new InvalidOperationException("Only draft audit programmes can be deleted.");

            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);
            return true;
        }
    }
}