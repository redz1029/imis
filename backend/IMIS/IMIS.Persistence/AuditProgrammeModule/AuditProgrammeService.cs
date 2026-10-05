using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanModule;
using IMIS.Application.IQASignatoryModule;
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
                entity.CreatedDate = DateTime.UtcNow;

                dbContext.Add(entity);
                await dbContext.SaveChangesAsync(cancellationToken);

                pDto.Id = entity.Id;
                pDto.StatusCode = IQAApprovalWorkflow.StateCodes.Draft;
                pDto.StatusName = IQAApprovalWorkflow.StateName(IQAApprovalWorkflow.StateCodes.Draft);
            }
            else
            {
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken);
                if (existing == null) throw new KeyNotFoundException("Audit Programme not found.");

                var preservedCreatedDate = existing.CreatedDate;

                dbContext.Entry(existing).CurrentValues.SetValues(entity);
                existing.CreatedDate = preservedCreatedDate;
                existing.LastModifiedDate = DateTime.UtcNow;

                // --- Sync Objectives ---
                if (existing.Objectives?.Any() == true)
                    _repository.RemoveObjectives(existing.Objectives.ToList());
                existing.Objectives = entity.Objectives;

                // --- Sync Audit Plans ---
                await UpdateAuditPlansAsync(dbContext, existing, entity, cancellationToken);

                await dbContext.SaveChangesAsync(cancellationToken);
            }
        }

        private async Task UpdateAuditPlansAsync(
            DbContext dbContext,
            AuditProgramme existing,
            AuditProgramme incoming,
            CancellationToken cancellationToken)
        {
            existing.AuditPlans ??= new List<AuditPlan>();
            incoming.AuditPlans ??= new List<AuditPlan>();

            var plansToRemove = existing.AuditPlans
                .Where(ep => !incoming.AuditPlans.Any(ip => ip.Id == ep.Id && ep.Id != 0))
                .ToList();

            foreach (var plan in plansToRemove)
            {
                existing.AuditPlans.Remove(plan);
                await RemovePlanWithChildrenAsync(dbContext, plan, cancellationToken);
            }

            foreach (var incomingPlan in incoming.AuditPlans)
            {
                var existingPlan = existing.AuditPlans
                    .FirstOrDefault(ep => ep.Id == incomingPlan.Id && ep.Id != 0);

                if (existingPlan == null)
                {
                    incomingPlan.AuditProgrammeId = existing.Id;
                    existing.AuditPlans.Add(incomingPlan);
                }
                else
                {
                    // FIX: removed existingPlan.AuditStatusId preservation —
                    // AuditPlan no longer has AuditStatusId. Status is derived
                    // from IQASignatory rows, which SetValues never touches
                    // (they are a navigation collection, not a scalar column).
                    // No special preservation needed here.
                    dbContext.Entry(existingPlan).CurrentValues.SetValues(incomingPlan);

                    await SyncAuditPlanEntriesAsync(dbContext, existingPlan, incomingPlan, cancellationToken);
                }
            }
        }

        private async Task SyncAuditPlanEntriesAsync(
            DbContext dbContext,
            AuditPlan existingPlan,
            AuditPlan incomingPlan,
            CancellationToken cancellationToken)
        {
            existingPlan.Entries ??= new List<AuditPlanEntry>();
            incomingPlan.Entries ??= new List<AuditPlanEntry>();

            var entriesToRemove = existingPlan.Entries
                .Where(ee => !incomingPlan.Entries.Any(ie => ie.Id == ee.Id && ee.Id != 0))
                .ToList();

            foreach (var entry in entriesToRemove)
            {
                existingPlan.Entries.Remove(entry);
                await RemoveEntryWithChildrenAsync(dbContext, entry, cancellationToken);
            }

            foreach (var incomingEntry in incomingPlan.Entries)
            {
                var existingEntry = existingPlan.Entries
                    .FirstOrDefault(ee => ee.Id == incomingEntry.Id && ee.Id != 0);

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

        private static async Task RemoveEntryWithChildrenAsync(
            DbContext dbContext,
            AuditPlanEntry entry,
            CancellationToken cancellationToken)
        {
            dbContext.Set<IsoStandardAuditPlan>().RemoveRange(
                await dbContext.Set<IsoStandardAuditPlan>()
                    .Where(x => x.AuditPlanEntryId == entry.Id).ToListAsync(cancellationToken));
            dbContext.Set<AuditPlanProcess>().RemoveRange(
                await dbContext.Set<AuditPlanProcess>()
                    .Where(x => x.AuditPlanEntryId == entry.Id).ToListAsync(cancellationToken));
            dbContext.Set<AuditPlanPersonResponsible>().RemoveRange(
                await dbContext.Set<AuditPlanPersonResponsible>()
                    .Where(x => x.AuditPlanEntryId == entry.Id).ToListAsync(cancellationToken));
            dbContext.Set<IsoAuditor>().RemoveRange(
                await dbContext.Set<IsoAuditor>()
                    .Where(x => x.AuditPlanEntryId == entry.Id).ToListAsync(cancellationToken));
            dbContext.Set<IsoAuditProcess>().RemoveRange(
                await dbContext.Set<IsoAuditProcess>()
                    .Where(x => x.AuditPlanEntryId == entry.Id).ToListAsync(cancellationToken));

            dbContext.Set<AuditPlanEntry>().Remove(entry);
        }

        private static async Task RemovePlanWithChildrenAsync(
    DbContext dbContext,
    AuditPlan plan,
    CancellationToken cancellationToken)
        {
            var entries = await dbContext.Set<AuditPlanEntry>()
                .Where(x => x.AuditPlanId == plan.Id).ToListAsync(cancellationToken);
            foreach (var entry in entries)
                await RemoveEntryWithChildrenAsync(dbContext, entry, cancellationToken);

            // The plan's approval chain. IQASignatory.AuditPlanId points at the plan, so
            // these rows must go first or deleting the plan fails on the foreign key.
            dbContext.Set<IQASignatory>().RemoveRange(
                await dbContext.Set<IQASignatory>()
                    .Where(x => x.AuditPlanId == plan.Id).ToListAsync(cancellationToken));

            // Same for the approval chains of this plan's schedules, before the schedules go.
            var schedules = await dbContext.Set<AuditSchedule>()
                .Where(x => x.AuditPlanId == plan.Id).ToListAsync(cancellationToken);
            var scheduleIds = schedules.Select(s => (int?)s.Id).ToList();
            if (scheduleIds.Count > 0)
            {
                dbContext.Set<IQASignatory>().RemoveRange(
                    await dbContext.Set<IQASignatory>()
                        .Where(x => scheduleIds.Contains(x.AuditScheduleId)).ToListAsync(cancellationToken));
            }

            dbContext.Set<AuditSchedule>().RemoveRange(schedules);

            dbContext.Set<AuditPlan>().Remove(plan);
        }

        private void SyncEntryGrandchildCollections(
            DbContext dbContext,
            AuditPlanEntry existingEntry,
            AuditPlanEntry incomingEntry)
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
            var processesToRemove = existingEntry.IsoAuditProcesses
                .Where(ep => !incomingEntry.IsoAuditProcesses.Any(ip => ip.Id == ep.Id && ep.Id != 0)).ToList();
            foreach (var p in processesToRemove)
            {
                existingEntry.IsoAuditProcesses.Remove(p);
                dbContext.Set<IsoAuditProcess>().Remove(p);
            }
            foreach (var incomingP in incomingEntry.IsoAuditProcesses)
            {
                var existingP = existingEntry.IsoAuditProcesses
                    .FirstOrDefault(ep => ep.Id == incomingP.Id && ep.Id != 0);
                if (existingP == null) { incomingP.AuditPlanEntryId = existingEntry.Id; existingEntry.IsoAuditProcesses.Add(incomingP); }
                else dbContext.Entry(existingP).CurrentValues.SetValues(incomingP);
            }

            // 2. ResponsiblePersons
            var personsToRemove = existingEntry.ResponsiblePersons
                .Where(er => !incomingEntry.ResponsiblePersons.Any(ir => ir.Id == er.Id && er.Id != 0)).ToList();
            foreach (var p in personsToRemove)
            {
                existingEntry.ResponsiblePersons.Remove(p);
                dbContext.Set<AuditPlanPersonResponsible>().Remove(p);
            }
            foreach (var incomingRp in incomingEntry.ResponsiblePersons)
            {
                var existingRp = existingEntry.ResponsiblePersons
                    .FirstOrDefault(er => er.Id == incomingRp.Id && er.Id != 0);
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
                    auditorProp.SetValue(incomingA, null);

                var existingA = existingEntry.IsoAuditors
                    .FirstOrDefault(ea => ea.Id == incomingA.Id && ea.Id != 0);
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
            var standardsToRemove = existingEntry.IsoStandardAuditPlans
                .Where(es => !incomingEntry.IsoStandardAuditPlans.Any(isPlan => isPlan.Id == es.Id && es.Id != 0)).ToList();
            foreach (var s in standardsToRemove)
            {
                existingEntry.IsoStandardAuditPlans.Remove(s);
                dbContext.Set<IsoStandardAuditPlan>().Remove(s);
            }
            foreach (var incomingS in incomingEntry.IsoStandardAuditPlans)
            {
                var existingS = existingEntry.IsoStandardAuditPlans
                    .FirstOrDefault(es => es.Id == incomingS.Id && es.Id != 0);
                if (existingS == null) { incomingS.AuditPlanEntryId = existingEntry.Id; existingEntry.IsoStandardAuditPlans.Add(incomingS); }
                else dbContext.Entry(existingS).CurrentValues.SetValues(incomingS);
            }

            // 5. AuditPlanProcesses
            var appToRemove = existingEntry.AuditPlanProcesses
                .Where(eap => !incomingEntry.AuditPlanProcesses.Any(iap => iap.Id == eap.Id && eap.Id != 0)).ToList();
            foreach (var ap in appToRemove)
            {
                existingEntry.AuditPlanProcesses.Remove(ap);
                dbContext.Set<AuditPlanProcess>().Remove(ap);
            }
            foreach (var incomingAp in incomingEntry.AuditPlanProcesses)
            {
                var existingAp = existingEntry.AuditPlanProcesses
                    .FirstOrDefault(eap => eap.Id == incomingAp.Id && eap.Id != 0);
                if (existingAp == null) { incomingAp.AuditPlanEntryId = existingEntry.Id; existingEntry.AuditPlanProcesses.Add(incomingAp); }
                else dbContext.Entry(existingAp).CurrentValues.SetValues(incomingAp);
            }
        }

        public async Task<List<string>> GetConflictValidationsAsync(
            AuditProgrammeDto dto,
            CancellationToken cancellationToken)
        {
            var errors = new List<string>();

            if (dto.Year < 2000 || dto.Year > 2100)
                errors.Add("Please provide a valid audit year.");

            if (dto.Objectives == null || !dto.Objectives.Any())
                errors.Add("An audit programme must have at least one objective.");

            return await Task.FromResult(errors);
        }

        public async Task<(bool Success, string? Error)> SubmitAsync(
            int id,
            CancellationToken cancellationToken)
        {
            return await SubmitAsync(id, null, null, cancellationToken);
        }

        public async Task<(bool Success, string? Error)> SubmitAsync(
            int id,
            string? userId,
            string? comments,
            CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var entity = await dbContext.Set<AuditProgramme>()
                .Include(x => x.Objectives)
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

            if (entity == null)
                return (false, "Audit programme not found.");

            var errors = await GetConflictValidationsAsync(new AuditProgrammeDto(entity), cancellationToken);
            if (errors.Any())
                return (false, string.Join(" ", errors));

            var result = await IQAApprovalWorkflow.SubmitAsync(
                dbContext, IQAApprovalWorkflow.EntityTypes.AuditProgramme, entity.Id,
                "audit programme", userId, comments, cancellationToken);
            if (!result.Success) return result;

            entity.LastModifiedDate = DateTime.UtcNow;
            return await SaveWorkflowChangesAsync(dbContext, cancellationToken);
        }

        public async Task<(bool Success, string? Error)> DecideAsync(
            int id,
            string approverId,
            bool approve,
            string? comments,
            CancellationToken cancellationToken)
        {
            return await DecideAsync(id, approverId, approve ? "Approve" : "Reject", comments, cancellationToken);
        }

        public async Task<(bool Success, string? Error)> DecideAsync(
            int id,
            string approverId,
            string action,
            string? comments,
            CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(approverId))
                return (false, "Approver is required.");

            var dbContext = _repository.GetDbContext();

            var entity = await dbContext.Set<AuditProgramme>()
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

            if (entity == null)
                return (false, "Audit programme not found.");

            var result = await IQAApprovalWorkflow.DecideAsync(
                dbContext, IQAApprovalWorkflow.EntityTypes.AuditProgramme, entity.Id,
                "audit programme", approverId, action, comments, null, cancellationToken);
            if (!result.Success) return result;

            entity.LastModifiedDate = DateTime.UtcNow;
            return await SaveWorkflowChangesAsync(dbContext, cancellationToken);
        }

        private static async Task<(bool Success, string? Error)> SaveWorkflowChangesAsync(
            DbContext dbContext,
            CancellationToken cancellationToken)
        {
            try
            {
                await dbContext.SaveChangesAsync(cancellationToken);
                return (true, null);
            }
            catch (DbUpdateConcurrencyException)
            {
                return (false, "This audit programme was changed by someone else. Please refresh and try again.");
            }
        }

        public async Task<DtoPageList<AuditProgrammeDto, AuditProgramme, int>> GetPaginatedAsync(
            int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            return DtoPageList<AuditProgrammeDto, AuditProgramme, int>.Create(
                result.Items, page, pageSize, result.TotalCount);
        }

        public async Task<AuditProgrammeDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken);
            return entity != null ? new AuditProgrammeDto(entity) : null;
        }

        public async Task<ReportAuditProgrammeDto?> ReportGetByIdAsync(
            int id,
            CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken)
                                          .ConfigureAwait(false);
            if (entity == null) return null;

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
                .Select(o => new ReportObjectiveItemDto { Id = o.Id, Text = o.Description ?? string.Empty })
                .ToList() ?? new List<ReportObjectiveItemDto>();

            if (entity.AuditPlans != null)
            {
                int batchCounter = 1;
                var formattedBatches = new List<ReportAuditPlanBatchDto>();

                foreach (var plan in entity.AuditPlans.OrderBy(p => p.StartDate))
                {
                    // FIX: was plan.AuditStatus?.Name — AuditPlan has no AuditStatusId/AuditStatus.
                    // Status is derived from the plan's IQASignatory rows, same as AuditProgramme.
                    var planStateCode = IQAApprovalWorkflow.DeriveStateCode(
                        IQAApprovalWorkflow.Ordered(plan.IQASignatories));

                    var reportBatch = new ReportAuditPlanBatchDto
                    {
                        Id = plan.Id,
                        StartDate = plan.StartDate,
                        EndDate = plan.EndDate,
                        PlanStatus = IQAApprovalWorkflow.StateName(planStateCode),
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
                                var officeNames = entry.AuditPlanProcesses.Select(app =>
                                {
                                    if (app.Office != null)
                                    {
                                        var cur = app.Office;
                                        var parent = cur.ParentOffice;
                                        string? dept = null, svc = null;
                                        while (parent != null)
                                        {
                                            if (parent.OfficeTypeId == 2) { dept = parent.Name; break; }
                                            if (parent.OfficeTypeId == 1) svc = parent.Name;
                                            parent = parent.ParentOffice;
                                        }
                                        if (!string.IsNullOrEmpty(dept)) return $"{dept} - {cur.Name}";
                                        if (!string.IsNullOrEmpty(svc) && cur.Name != svc) return $"{svc} - {cur.Name}";
                                        return cur.Name;
                                    }
                                    if (!string.IsNullOrWhiteSpace(app.ProcessName)) return app.ProcessName!.Trim();
                                    return app.OfficeId != null ? $"Office {app.OfficeId}" : $"Process {app.Id}";
                                }).Where(n => !string.IsNullOrEmpty(n)).ToList();

                                if (officeNames.Any())
                                    officeNamesCombined = string.Join(Environment.NewLine, officeNames);
                            }
                            else if (entry.IsoAuditProcesses != null && entry.IsoAuditProcesses.Any())
                            {
                                var processNames = entry.IsoAuditProcesses
                                    .Select(p => p.Name)
                                    .Where(n => !string.IsNullOrEmpty(n)).ToList();
                                if (processNames.Any())
                                    officeNamesCombined = string.Join(Environment.NewLine, processNames);
                            }

                            string standardChaptersCombined = "N/A";
                            if (entry.IsoStandardAuditPlans != null && entry.IsoStandardAuditPlans.Any())
                            {
                                var clauses = entry.IsoStandardAuditPlans
                                    .Where(isap => isap.IsoStandard != null
                                                   && !string.IsNullOrEmpty(isap.IsoStandard.ClauseRef))
                                    .Select(isap => isap.IsoStandard.ClauseRef)
                                    .OrderBy(c => c).ToList();
                                if (clauses.Any())
                                    standardChaptersCombined = string.Join(", ", clauses);
                            }

                            string auditorsLinesCombined = string.Empty;
                            if (entry.IsoAuditors != null && entry.IsoAuditors.Any())
                            {
                                var first = entry.IsoAuditors.FirstOrDefault();
                                if (first != null)
                                    auditorsLinesCombined = first.Team != null
                                        ? first.Team.Name
                                        : $"Team {first.TeamId ?? 1}";
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

        public async Task<List<AuditProgrammeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAllAsync(cancellationToken);
            return entities?.Select(e => new AuditProgrammeDto(e)).ToList()
                   ?? new List<AuditProgrammeDto>();
        }

        public async Task<List<AuditProgrammeDto>> GetApprovedAsync(CancellationToken cancellationToken)
        {
            var all = await GetAllAsync(cancellationToken);
            return all?.Where(p => p.StatusCode == IQAApprovalWorkflow.StateCodes.Approved).ToList()
                   ?? new List<AuditProgrammeDto>();
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null) return false;

            var dbContext = _repository.GetDbContext();

            var state = await IQAApprovalWorkflow.GetStateCodeAsync(
                dbContext, IQAApprovalWorkflow.EntityTypes.AuditProgramme, id, cancellationToken);
            if (state != IQAApprovalWorkflow.StateCodes.Draft)
                throw new InvalidOperationException("Only draft audit programmes can be deleted.");

            entity.IsDeleted = true;
            await dbContext.SaveChangesAsync(cancellationToken);
            return true;
        }

        private string FormatBatchDateRange(DateTime start, DateTime end)
        {
            if (start.Date == end.Date)
                return start.ToString("MMMM dd, yyyy");
            if (start.Month == end.Month && start.Year == end.Year)
                return $"{start:MMMM dd} - {end:dd, yyyy}";
            if (start.Year == end.Year)
                return $"{start:MMMM dd} - {end:MMMM dd, yyyy}";
            return $"{start:MMMM dd, yyyy} - {end:MMMM dd, yyyy}";
        }
    }
}
