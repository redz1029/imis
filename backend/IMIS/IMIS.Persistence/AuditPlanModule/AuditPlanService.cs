using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanModule;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditPlanModule
{
    public class AuditPlanService : IAuditPlanService
    {
        private readonly IAuditPlanRepository _repository;

        public AuditPlanService(IAuditPlanRepository repository)
        {
            _repository = repository;
        }

        // ------------------------------------------------------------------ //
        //  Transition table — mirrors AuditProgrammeService exactly.          //
        // ------------------------------------------------------------------ //
        private static readonly Dictionary<string, string[]> _allowedTransitions = new()
        {
            [AuditStatusCodes.Draft] = new[] { AuditStatusCodes.Pending },
            [AuditStatusCodes.Pending] = new[] { AuditStatusCodes.Approved, AuditStatusCodes.Disapproved },
            [AuditStatusCodes.Disapproved] = new[] { AuditStatusCodes.Draft },
            [AuditStatusCodes.Approved] = Array.Empty<string>(),
        };

        // ------------------------------------------------------------------ //
        //  Save / Update                                                       //
        // ------------------------------------------------------------------ //

        public async Task<bool> SaveAuditPlanAsync(AuditPlanDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) return false;
            await SaveOrUpdateAsync(dto, cancellationToken);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not AuditPlanDto aDto)
                throw new InvalidOperationException("Invalid DTO type.");

            var entity = aDto.ToEntity();
            var dbContext = _repository.GetDbContext();

            if (entity.Id == 0)
            {
                // BRAND NEW — always Draft, stated explicitly so it can't drift.
                entity.AuditStatusId = AuditStatusSeedIds.Draft;
                entity.CreatedDate = DateTime.UtcNow;

                // Push StartDate/EndDate onto any schedules in the same payload
                // before EF assigns identities, so the insert carries correct dates.
                entity.SyncScheduleDates();

                dbContext.Add(entity);
                await dbContext.SaveChangesAsync(cancellationToken);
            }
            else
            {
                // EXISTING UPDATE
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken);
                if (existing == null) throw new KeyNotFoundException("Audit Plan not found.");

                // FIX: preserve status — SetValues would otherwise overwrite the
                // real status with the DTO's default, silently reverting a
                // Pending/Approved plan back to Draft on every ordinary edit.
                var preservedStatusId = existing.AuditStatusId;

                dbContext.Entry(existing).CurrentValues.SetValues(entity);
                existing.AuditStatusId = preservedStatusId;
                existing.LastModifiedDate = DateTime.UtcNow;

                // --- Sync Approvals ---
                existing.Approvals ??= new List<AuditPlanApproval>();
                entity.Approvals ??= new List<AuditPlanApproval>();

                var approvalsToRemove = existing.Approvals
                    .Where(ea => !entity.Approvals.Any(ia => ia.Id == ea.Id && ea.Id != 0))
                    .ToList();
                foreach (var approval in approvalsToRemove)
                {
                    existing.Approvals.Remove(approval);
                    dbContext.Set<AuditPlanApproval>().Remove(approval);
                }
                foreach (var incomingApproval in entity.Approvals)
                {
                    var existingApproval = existing.Approvals
                        .FirstOrDefault(ea => ea.Id == incomingApproval.Id && ea.Id != 0);
                    if (existingApproval == null)
                        existing.Approvals.Add(incomingApproval);
                    else
                        dbContext.Entry(existingApproval).CurrentValues.SetValues(incomingApproval);
                }

                // --- Sync AuditSchedules ---
                existing.AuditSchedules ??= new List<AuditSchedule>();
                entity.AuditSchedules ??= new List<AuditSchedule>();

                var schedulesToRemove = existing.AuditSchedules
                    .Where(es => !entity.AuditSchedules.Any(is_ => is_.Id == es.Id && es.Id != 0))
                    .ToList();
                foreach (var schedule in schedulesToRemove)
                {
                    existing.AuditSchedules.Remove(schedule);
                    dbContext.Set<AuditSchedule>().Remove(schedule);
                }
                foreach (var incomingSchedule in entity.AuditSchedules)
                {
                    var existingSchedule = existing.AuditSchedules
                        .FirstOrDefault(es => es.Id == incomingSchedule.Id && es.Id != 0);
                    if (existingSchedule == null)
                    {
                        incomingSchedule.AuditPlanId = existing.Id;
                        existing.AuditSchedules.Add(incomingSchedule);
                    }
                    else
                    {
                        dbContext.Entry(existingSchedule).CurrentValues.SetValues(incomingSchedule);
                    }
                }

                // --- Sync Entries & Deep Sub-Collections ---
                existing.Entries ??= new List<AuditPlanEntry>();
                entity.Entries ??= new List<AuditPlanEntry>();

                var entriesToRemove = existing.Entries
                    .Where(ee => !entity.Entries.Any(ie => ie.Id == ee.Id && ee.Id != 0))
                    .ToList();
                foreach (var entry in entriesToRemove)
                {
                    existing.Entries.Remove(entry);
                    dbContext.Set<AuditPlanEntry>().Remove(entry);
                }
                foreach (var incomingEntry in entity.Entries)
                {
                    var existingEntry = existing.Entries
                        .FirstOrDefault(ee => ee.Id == incomingEntry.Id && ee.Id != 0);
                    if (existingEntry == null)
                    {
                        incomingEntry.AuditPlanId = existing.Id;
                        existing.Entries.Add(incomingEntry);
                    }
                    else
                    {
                        dbContext.Entry(existingEntry).CurrentValues.SetValues(incomingEntry);
                        SyncEntryGrandchildCollections(dbContext, existingEntry, incomingEntry);
                    }
                }

                // Push updated StartDate/EndDate onto every linked schedule
                // right before the terminal save so plan and schedule dates never drift.
                existing.SyncScheduleDates();

                await dbContext.SaveChangesAsync(cancellationToken);
            }
        }

        // ------------------------------------------------------------------ //
        //  Status transition                                                   //
        // ------------------------------------------------------------------ //

        public async Task<(bool Success, string? Error)> ChangeStatusAsync(
            int id,
            string newStatusCode,
            string? remarks,
            CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var entity = await dbContext.Set<AuditPlan>()
                .Include(x => x.AuditStatus)
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

            if (entity?.AuditStatus == null)
                return (false, "Audit plan not found.");

            var currentCode = entity.AuditStatus.Code;

            if (!_allowedTransitions.TryGetValue(currentCode, out var allowed)
                || !allowed.Contains(newStatusCode))
                return (false, $"Cannot move from {currentCode} to {newStatusCode}.");

            var newStatus = await dbContext.Set<AuditPlanStatus>()
                .FirstOrDefaultAsync(s => s.Code == newStatusCode, cancellationToken);
            if (newStatus == null)
                return (false, $"Status '{newStatusCode}' does not exist.");

            // FIX: Draft-only delete guard lives in SoftDeleteAsync.
            // Status guard lives here. The two are separate so neither needs
            // to know about the other's concerns.
            entity.AuditStatusId = newStatus.Id;
            entity.LastModifiedDate = DateTime.UtcNow;

            await dbContext.SaveChangesAsync(cancellationToken);
            return (true, null);
        }

        // ------------------------------------------------------------------ //
        //  Soft delete — Draft-only guard                                      //
        // ------------------------------------------------------------------ //

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null) return false;

            if (entity.AuditStatusId != AuditStatusSeedIds.Draft)
                throw new InvalidOperationException("Only draft audit plans can be deleted.");

            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);
            return true;
        }

        // ------------------------------------------------------------------ //
        //  Retrieval                                                           //
        // ------------------------------------------------------------------ //

        public async Task<List<AuditPlanDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAllAsync(cancellationToken);
            return entities?.Select(e => new AuditPlanDto(e)).ToList();
        }

        public async Task<AuditPlanDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken);
            return entity != null ? new AuditPlanDto(entity) : null;
        }

        public async Task<AuditPlanDto?> GetByProgrammeIdAsync(int programmeId, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var id = await dbContext.Set<AuditPlan>()
                .Where(a => a.AuditProgrammeId == programmeId && !a.IsDeleted)
                .Select(a => a.Id)
                .FirstOrDefaultAsync(cancellationToken);

            if (id == 0) return null;

            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken);
            return entity != null ? new AuditPlanDto(entity) : null;
        }

        // FIX: was returning null! on empty page — same anti-pattern as
        // AuditProgrammeService. Empty page is a valid answer, not null.
        public async Task<DtoPageList<AuditPlanDto, AuditPlan, int>> GetPaginatedAsync(
            int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            return DtoPageList<AuditPlanDto, AuditPlan, int>.Create(result.Items, page, pageSize, result.TotalCount);
        }

        // ------------------------------------------------------------------ //
        //  Validation                                                          //
        // ------------------------------------------------------------------ //

        public async Task<List<string>> GetConflictValidationsAsync(AuditPlanDto dto, CancellationToken cancellationToken)
        {
            var errors = new List<string>();

            if (dto.StartDate > dto.EndDate)
                errors.Add("Start date cannot be greater than end date.");

            // REMOVED: string PlanStatus null-check — field no longer exists.
            // Status is enforced by the FK default and transition guard instead.

            if (dto.Entries == null || !dto.Entries.Any())
                errors.Add("At least one Audit Plan Entry is required.");

            return errors;
        }

        // ------------------------------------------------------------------ //
        //  Report                                                              //
        // ------------------------------------------------------------------ //

        public async Task<ReportAuditPlanDto?> ReportGetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken)
                                          .ConfigureAwait(false);
            if (entity == null) return null;

            var dto = new ReportAuditPlanDto
            {
                Id = entity.Id,
                StartDate = entity.StartDate,
                EndDate = entity.EndDate,
                // FIXED: was entity.PlanStatus ?? "Draft" — field removed.
                // Use the real status name from the navigation property instead.
                PlanStatus = entity.AuditStatus?.Name ?? "Draft",
                BatchFormattedDates = FormatBatchDateRange(entity.StartDate, entity.EndDate),
                IsDeleted = entity.IsDeleted,
                RowVersion = entity.RowVersion,

                AuditPlanObjective = entity.AuditProgramme?.AuditPlanObjective ?? string.Empty,
                ScopeOfAudit = entity.AuditProgramme?.ScopeOfAudit ?? string.Empty,

                PreparedByName = ResolvePreparerName(entity.Preparer),
                PreparedByDate = entity.CreatedDate.ToString("MMMM dd, yyyy"),

                FlatEntries = new List<ReportScheduleEntryDto>()
            };

            var latestApproval = entity.Approvals?
                .Where(a => string.Equals(a.Action, "Approved", StringComparison.OrdinalIgnoreCase))
                .OrderByDescending(a => a.Timestamp)
                .FirstOrDefault();

            if (latestApproval != null)
            {
                dto.ApprovedByName = ResolveUserName(latestApproval.Approver);
                dto.ApprovedByDate = latestApproval.Timestamp.ToString("MMMM dd, yyyy");
            }

            if (entity.Entries != null && entity.Entries.Any())
            {
                int maxDay = entity.Entries.Max(e => e.DayNumber);

                foreach (var entry in entity.Entries.OrderBy(e => e.DayNumber).ThenBy(e => e.Time))
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
                                        if (parent.OfficeTypeId == 2) { departmentName = parent.Name; break; }
                                        if (parent.OfficeTypeId == 1) serviceName = parent.Name;
                                        parent = parent.ParentOffice;
                                    }

                                    if (!string.IsNullOrEmpty(departmentName))
                                        return $"{departmentName} - {currentOffice.Name}";
                                    if (!string.IsNullOrEmpty(serviceName) && currentOffice.Name != serviceName)
                                        return $"{serviceName} - {currentOffice.Name}";

                                    return currentOffice.Name;
                                }

                                if (!string.IsNullOrWhiteSpace(app.ProcessName))
                                    return app.ProcessName!.Trim();

                                return app.OfficeId != null ? $"Office {app.OfficeId}" : $"Process {app.Id}";
                            })
                            .Where(name => !string.IsNullOrEmpty(name))
                            .ToList();

                        if (officeNames.Any())
                            officeNamesCombined = string.Join(Environment.NewLine, officeNames);
                    }
                    else if (entry.IsoAuditProcesses != null && entry.IsoAuditProcesses.Any())
                    {
                        var processNames = entry.IsoAuditProcesses
                            .Select(p => p.Name)
                            .Where(name => !string.IsNullOrEmpty(name))
                            .ToList();

                        if (processNames.Any())
                            officeNamesCombined = string.Join(Environment.NewLine, processNames);
                    }

                    string standardChaptersCombined = "N/A";
                    if (entry.IsoStandardAuditPlans != null && entry.IsoStandardAuditPlans.Any())
                    {
                        var clauses = entry.IsoStandardAuditPlans
                            .Where(isap => isap.IsoStandard != null && !string.IsNullOrEmpty(isap.IsoStandard.ClauseRef))
                            .Select(isap => isap.IsoStandard!.ClauseRef)
                            .OrderBy(clause => clause)
                            .ToList();

                        if (clauses.Any())
                            standardChaptersCombined = string.Join(", ", clauses);
                    }

                    string auditorsLinesCombined = "Unassigned";
                    if (entry.ResponsiblePersons != null && entry.ResponsiblePersons.Any())
                    {
                        var names = entry.ResponsiblePersons
                            .Select(r => r.Name)
                            .Where(n => !string.IsNullOrWhiteSpace(n))
                            .ToList();

                        if (names.Any())
                            auditorsLinesCombined = string.Join(Environment.NewLine, names);
                    }
                    else if (entry.IsoAuditors != null && entry.IsoAuditors.Any())
                    {
                        var firstAuditorNode = entry.IsoAuditors.FirstOrDefault();
                        if (firstAuditorNode != null)
                        {
                            auditorsLinesCombined = firstAuditorNode.Team != null
                                ? firstAuditorNode.Team.Name
                                : $"Team {firstAuditorNode.TeamId ?? 1}";
                        }
                    }

                    DateTime calculatedEntryDate = entity.StartDate.AddDays(entry.DayNumber - 1);

                    dto.FlatEntries.Add(new ReportScheduleEntryDto
                    {
                        Id = entry.Id,
                        DayNumber = entry.DayNumber,
                        Time = entry.Time,
                        TotalDaysInBatch = maxDay,
                        FormattedOfficeNames = officeNamesCombined.Trim(),
                        FormattedStandardChapters = standardChaptersCombined.Trim(),
                        FormattedProposedSchedule = calculatedEntryDate.ToString("MMMM dd, yyyy"),
                        FormattedAuditorTeamAndMembers = auditorsLinesCombined
                    });
                }
            }

            return dto;
        }

        // ------------------------------------------------------------------ //
        //  Private helpers                                                     //
        // ------------------------------------------------------------------ //

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

            SyncCollection(dbContext, existingEntry.IsoAuditProcesses, incomingEntry.IsoAuditProcesses,
                p => { p.AuditPlanEntryId = existingEntry.Id; });

            SyncCollection(dbContext, existingEntry.ResponsiblePersons, incomingEntry.ResponsiblePersons,
                p => { p.AuditPlanEntryId = existingEntry.Id; });

            SyncCollection(dbContext, existingEntry.IsoAuditors, incomingEntry.IsoAuditors,
                a => { a.AuditPlanEntryId = existingEntry.Id; });

            // IsoStandardAuditPlan doesn't derive from Entity<int>, so it can't use the
            // generic SyncCollection<T> helper — synced by hand instead.
            var standardsToRemove = existingEntry.IsoStandardAuditPlans
                .Where(es => !incomingEntry.IsoStandardAuditPlans.Any(isPlan => isPlan.Id == es.Id && es.Id != 0))
                .ToList();
            foreach (var s in standardsToRemove)
            {
                existingEntry.IsoStandardAuditPlans.Remove(s);
                dbContext.Set<IsoStandardAuditPlan>().Remove(s);
            }
            foreach (var incomingS in incomingEntry.IsoStandardAuditPlans)
            {
                var existingS = existingEntry.IsoStandardAuditPlans
                    .FirstOrDefault(es => es.Id == incomingS.Id && es.Id != 0);
                if (existingS == null)
                {
                    incomingS.AuditPlanEntryId = existingEntry.Id;
                    existingEntry.IsoStandardAuditPlans.Add(incomingS);
                }
                else
                {
                    dbContext.Entry(existingS).CurrentValues.SetValues(incomingS);
                }
            }

            SyncCollection(dbContext, existingEntry.AuditPlanProcesses, incomingEntry.AuditPlanProcesses,
                ap => { ap.AuditPlanEntryId = existingEntry.Id; });
        }

        // Generic add/update/remove sync — extracted to remove the five
        // copy-pasted blocks that were in the original SyncEntryGrandchildCollections.
        private static void SyncCollection<T>(
            DbContext dbContext,
            ICollection<T> existing,
            ICollection<T> incoming,
            Action<T> setParentId) where T : Entity<int>
        {
            var toRemove = existing
                .Where(e => !incoming.Any(i => i.Id == e.Id && e.Id != 0))
                .ToList();

            foreach (var item in toRemove)
            {
                existing.Remove(item);
                dbContext.Set<T>().Remove(item);
            }

            foreach (var incomingItem in incoming)
            {
                var existingItem = existing.FirstOrDefault(e => e.Id == incomingItem.Id && e.Id != 0);
                if (existingItem == null)
                {
                    setParentId(incomingItem);
                    existing.Add(incomingItem);
                }
                else
                {
                    dbContext.Entry(existingItem).CurrentValues.SetValues(incomingItem);
                }
            }
        }

        private static string ResolvePreparerName(IsoAuditor? preparer) =>
            ResolveAuditorName(preparer?.IsoAuditors);

        private static string ResolveAuditorName(Auditor? auditor) =>
            ResolveUserName(auditor?.User);

        private static string ResolveUserName(User? user)
        {
            if (user == null) return string.Empty;
            var parts = new[] { user.Prefix, user.FirstName, user.MiddleName, user.LastName, user.Suffix }
                .Where(p => !string.IsNullOrWhiteSpace(p));
            return string.Join(" ", parts);
        }

        private static string FormatBatchDateRange(DateTime start, DateTime end)
        {
            if (start.Month == end.Month && start.Year == end.Year)
            {
                if (start.Day == end.Day) return $"{start:MMMM dd, yyyy}";
                return $"{start:MMMM d} – {end:d, yyyy}";
            }
            return $"{start:MMMM dd, yyyy} - {end:MMMM dd, yyyy}";
        }
    }
}
