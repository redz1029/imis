using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanModule;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Application.IQASignatoryModule;
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
                // New plan: no signatory rows yet, which IS the Draft state.
                entity.CreatedDate = DateTime.UtcNow;

                // Push StartDate/EndDate onto any schedules in the same payload
                // before EF assigns identities, so the insert carries correct dates.
                entity.SyncScheduleDates();

                dbContext.Add(entity);
                await dbContext.SaveChangesAsync(cancellationToken);

                // ToEntity() builds a separate object graph; hand the generated id
                // back to the caller's dto (the POST endpoint echoes it).
                aDto.Id = entity.Id;
                aDto.StatusCode = IQAApprovalWorkflow.StateCodes.Draft;
                aDto.StatusName = IQAApprovalWorkflow.StateName(IQAApprovalWorkflow.StateCodes.Draft);
            }
            else
            {
                // EXISTING UPDATE
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken);
                if (existing == null) throw new KeyNotFoundException("Audit Plan not found.");

                // SetValues copies every scalar from the freshly built entity,
                // including CreatedDate (whatever the client sent). Preserve the real one.
                var preservedCreatedDate = existing.CreatedDate;

                dbContext.Entry(existing).CurrentValues.SetValues(entity);
                existing.CreatedDate = preservedCreatedDate;
                existing.LastModifiedDate = DateTime.UtcNow;

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
        //  Approval workflow (IQA signatories)                                 //
        // ------------------------------------------------------------------ //

        public async Task<(bool Success, string? Error)> SubmitAsync(int id, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var entity = await dbContext.Set<AuditPlan>()
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

            if (entity == null)
                return (false, "Audit plan not found.");

            var entryCount = await dbContext.Set<AuditPlanEntry>()
                .CountAsync(e => e.AuditPlanId == id && !e.IsDeleted, cancellationToken);

            var errors = BuildValidationErrors(entity.StartDate, entity.EndDate, entryCount);
            if (errors.Any())
                return (false, string.Join(" ", errors));

            var result = await IQAApprovalWorkflow.SubmitAsync(
                dbContext, IQAApprovalWorkflow.EntityTypes.AuditPlan, entity.Id, "audit plan", cancellationToken);
            if (!result.Success)
                return result;

            // Touching the plan row also makes a concurrent double-submit
            // fail on the row version instead of creating two chains.
            entity.LastModifiedDate = DateTime.UtcNow;
            return await SaveWorkflowChangesAsync(dbContext, cancellationToken);
        }

        public async Task<(bool Success, string? Error)> DecideAsync(
            int id, string approverId, bool approve, string? comments, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(approverId))
                return (false, "Approver is required.");

            var dbContext = _repository.GetDbContext();

            var entity = await dbContext.Set<AuditPlan>()
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

            if (entity == null)
                return (false, "Audit plan not found.");

            var result = await IQAApprovalWorkflow.DecideAsync(
                dbContext, IQAApprovalWorkflow.EntityTypes.AuditPlan, entity.Id, "audit plan",
                approverId, approve, comments, cancellationToken);
            if (!result.Success)
                return result;

            entity.LastModifiedDate = DateTime.UtcNow;
            return await SaveWorkflowChangesAsync(dbContext, cancellationToken);
        }

        private static async Task<(bool Success, string? Error)> SaveWorkflowChangesAsync(DbContext dbContext, CancellationToken cancellationToken)
        {
            try
            {
                await dbContext.SaveChangesAsync(cancellationToken);
                return (true, null);
            }
            catch (DbUpdateConcurrencyException)
            {
                return (false, "This audit plan was changed by someone else. Please refresh and try again.");
            }
        }

        // ------------------------------------------------------------------ //
        //  Soft delete — Draft-only guard                                      //
        // ------------------------------------------------------------------ //

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null) return false;

            var dbContext = _repository.GetDbContext();

            var state = await IQAApprovalWorkflow.GetStateCodeAsync(
                dbContext, IQAApprovalWorkflow.EntityTypes.AuditPlan, id, cancellationToken);
            if (state != IQAApprovalWorkflow.StateCodes.Draft)
                throw new InvalidOperationException("Only draft audit plans can be deleted.");

            entity.IsDeleted = true;
            await dbContext.SaveChangesAsync(cancellationToken);
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
            // Status is no longer a field on the plan; it is derived from the signatory rows.
            return await Task.FromResult(BuildValidationErrors(dto.StartDate, dto.EndDate, dto.Entries?.Count ?? 0));
        }

        private static List<string> BuildValidationErrors(DateTime startDate, DateTime endDate, int entryCount)
        {
            var errors = new List<string>();

            if (startDate > endDate)
                errors.Add("Start date cannot be greater than end date.");

            if (entryCount == 0)
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

            var dbContext = _repository.GetDbContext();

            // Programme objective/scope — loaded directly so the report doesn't
            // depend on the repository having included AuditProgramme.
            var programmeText = await dbContext.Set<AuditPlan>()
                .AsNoTracking()
                .Where(p => p.Id == id)
                .Select(p => new
                {
                    Objective = p.AuditProgramme!.AuditPlanObjective,
                    Scope = p.AuditProgramme!.ScopeOfAudit
                })
                .FirstOrDefaultAsync(cancellationToken)
                .ConfigureAwait(false);

            // Per-entry team, auditors and standards — loaded directly so the report
            // doesn't depend on the repository's Includes.
            var entriesWithAuditors = await dbContext.Set<AuditPlanEntry>()
                .AsNoTracking()
                .AsSplitQuery()
                .Where(e => e.AuditPlanId == id)
                .Include(e => e.IsoAuditors).ThenInclude(a => a.Team)
                .Include(e => e.IsoAuditors).ThenInclude(a => a.IsoAuditors).ThenInclude(au => au.User)
                .Include(e => e.IsoStandardAuditPlans).ThenInclude(s => s.IsoStandard)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            var auditorsByEntryId = entriesWithAuditors.ToDictionary(
                e => e.Id,
                e => e.IsoAuditors?.ToList() ?? new List<IsoAuditor>());

            var standardsByEntryId = entriesWithAuditors.ToDictionary(
                e => e.Id,
                e => e.IsoStandardAuditPlans?.ToList() ?? new List<IsoStandardAuditPlan>());

            // Team rosters. Plan entries generated from the Audit Programme carry
            // only a TeamId (no per-entry auditors), so the team's members come
            // from the AuditorTeams roster — the same source the Plan page's
            // "Fetch from Team" button uses.
            var rosterTeamIds = entriesWithAuditors
                .SelectMany(e => e.IsoAuditors ?? new List<IsoAuditor>())
                .Select(x => x.TeamId)
                .Where(x => x != null)
                .Distinct()
                .ToList();

            var rosterRows = rosterTeamIds.Count == 0
                ? new List<AuditorTeams>()
                : await dbContext.Set<AuditorTeams>()
                    .AsNoTracking()
                    .Where(t => rosterTeamIds.Contains(t.TeamId) && t.IsActive == true && t.IsDeleted != true)
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);

            var rosterAuditorIds = rosterRows
                .Select(r => (int?)r.AuditorId)
                .Where(x => x != null)
                .Select(x => x!.Value)
                .Distinct()
                .ToList();

            var rosterAuditors = rosterAuditorIds.Count == 0
                ? new List<Auditor>()
                : await dbContext.Set<Auditor>()
                    .AsNoTracking()
                    .Include(a => a.User)
                    .Where(a => rosterAuditorIds.Contains(a.Id))
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);

            var rosterAuditorById = rosterAuditors.ToDictionary(a => a.Id);

            var rosterByTeamId = rosterRows
                .Where(r => (int?)r.TeamId != null)
                .GroupBy(r => ((int?)r.TeamId)!.Value)
                .ToDictionary(g => g.Key, g => g.OrderBy(r => r.Id).ToList());

            var dto = new ReportAuditPlanDto
            {
                Id = entity.Id,
                StartDate = entity.StartDate,
                EndDate = entity.EndDate,
                PlanStatus = IQAApprovalWorkflow.StateName(IQAApprovalWorkflow.DeriveStateCode(entity.IQASignatories)),
                BatchFormattedDates = FormatBatchDateRange(entity.StartDate, entity.EndDate),
                IsDeleted = entity.IsDeleted,
                RowVersion = entity.RowVersion,

                AuditPlanObjective = programmeText?.Objective
                                     ?? entity.AuditProgramme?.AuditPlanObjective
                                     ?? string.Empty,
                ScopeOfAudit = programmeText?.Scope
                               ?? entity.AuditProgramme?.ScopeOfAudit
                               ?? string.Empty,

                PreparedByName = ResolvePreparerName(entity.Preparer),
                PreparedByDate = entity.CreatedDate.ToString("MMMM dd, yyyy"),

                FlatEntries = new List<ReportScheduleEntryDto>()
            };

            // "Approved by" is the last person to sign, and only once the whole chain has approved.
            var liveSignatories = IQAApprovalWorkflow.Ordered(entity.IQASignatories);
            if (IQAApprovalWorkflow.DeriveStateCode(liveSignatories) == IQAApprovalWorkflow.StateCodes.Approved)
            {
                var finalSigner = liveSignatories
                    .Where(sig => sig.DateSigned != null)
                    .OrderByDescending(sig => sig.DateSigned)
                    .FirstOrDefault();

                if (finalSigner != null)
                {
                    dto.ApprovedByName = ResolveUserName(finalSigner.Signatory);
                    dto.ApprovedByDate = finalSigner.DateSigned!.Value.ToString("MMMM dd, yyyy");
                }
            }

            if (entity.Entries != null && entity.Entries.Any())
            {
                int maxDay = entity.Entries.Max(e => e.DayNumber);

                foreach (var entry in entity.Entries.OrderBy(e => e.DayNumber).ThenBy(e => e.Time))
                {
                    // ---------------- Organizational unit and process ----------------
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

                    // ---------------- Standard ----------------
                    string standardChaptersCombined = "N/A";
                    if (standardsByEntryId.TryGetValue(entry.Id, out var entryStandards) && entryStandards.Count > 0)
                    {
                        var clauses = entryStandards
                            .Select(s => s.IsoStandard != null ? s.IsoStandard.ClauseRef : s.IsoStandardId.ToString())
                            .Where(c => !string.IsNullOrWhiteSpace(c))
                            .Select(c => c!.Trim())
                            .Distinct()
                            .OrderBy(c => ClauseSortKey(c), StringComparer.Ordinal)
                            .ToList();

                        if (clauses.Any())
                            standardChaptersCombined = string.Join(", ", clauses);
                    }

                    // ---------------- Audit team / person responsible ----------------
                    // Team label, then that team's member names; a blank line separates
                    // teams. Members come from (1) auditors saved on the entry itself,
                    // else (2) the team's active AuditorTeams roster — unless the entry
                    // already has saved responsible persons, which are printed as-is.
                    var auditorLines = new List<string>();
                    var seenNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

                    bool hasSavedPersons = entry.ResponsiblePersons != null
                        && entry.ResponsiblePersons.Any(p => !string.IsNullOrWhiteSpace(p.Name));

                    if (auditorsByEntryId.TryGetValue(entry.Id, out var entryAuditorRows) && entryAuditorRows.Count > 0)
                    {
                        bool firstGroup = true;
                        foreach (var teamGroup in entryAuditorRows.GroupBy(a => a.TeamId).OrderBy(g => g.Key))
                        {
                            if (!firstGroup) auditorLines.Add(string.Empty);
                            firstGroup = false;

                            if (teamGroup.Key != null)
                            {
                                var teamName = teamGroup.Select(a => a.Team?.Name)
                                                        .FirstOrDefault(n => !string.IsNullOrWhiteSpace(n));
                                auditorLines.Add(!string.IsNullOrWhiteSpace(teamName)
                                    ? teamName!
                                    : $"Team {teamGroup.Key}");
                            }

                            int linesBeforeMembers = auditorLines.Count;

                            foreach (var member in teamGroup)
                            {
                                var memberName = FormatMemberName(member.IsoAuditors?.User);
                                if (!string.IsNullOrWhiteSpace(memberName) && seenNames.Add(memberName))
                                    auditorLines.Add(memberName);
                            }

                            bool teamHasOwnMembers = auditorLines.Count > linesBeforeMembers;

                            if (!teamHasOwnMembers
                                && !hasSavedPersons
                                && teamGroup.Key != null
                                && rosterByTeamId.TryGetValue(teamGroup.Key.Value, out var roster))
                            {
                                var rosterSeen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                                foreach (var row in roster)
                                {
                                    var rosterAuditorId = (int?)row.AuditorId;
                                    if (rosterAuditorId == null
                                        || !rosterAuditorById.TryGetValue(rosterAuditorId.Value, out var rosterAuditor))
                                        continue;

                                    var rosterName = FormatMemberName(rosterAuditor.User);
                                    if (!string.IsNullOrWhiteSpace(rosterName) && rosterSeen.Add(rosterName))
                                        auditorLines.Add(rosterName);
                                }
                            }
                        }
                    }

                    if (entry.ResponsiblePersons != null)
                    {
                        foreach (var person in entry.ResponsiblePersons)
                        {
                            var personName = person.Name?.Trim();
                            if (!string.IsNullOrWhiteSpace(personName) && seenNames.Add(personName))
                                auditorLines.Add(personName);
                        }
                    }

                    string auditorsLinesCombined = auditorLines.Any()
                        ? string.Join(Environment.NewLine, auditorLines)
                        : "Unassigned";

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

        // Team-member display name in the printed-form style: "Ms. C. M. Ferrer"
        // (prefix, first and middle initials, last name, suffix). To print full
        // names instead, change the two FormatMemberName(...) calls in
        // ReportGetByIdAsync to ResolveUserName(...).
        private static string FormatMemberName(User? user)
        {
            if (user == null) return string.Empty;

            static string Initials(string? text)
            {
                if (string.IsNullOrWhiteSpace(text)) return string.Empty;
                var letters = text
                    .Split(new[] { ' ', '.' }, StringSplitOptions.RemoveEmptyEntries)
                    .Select(w => char.ToUpperInvariant(w[0]) + ".");
                return string.Join(" ", letters);
            }

            var parts = new[]
            {
                user.Prefix,
                Initials(user.FirstName),
                Initials(user.MiddleName),
                user.LastName,
                user.Suffix
            }.Where(p => !string.IsNullOrWhiteSpace(p));

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

        // Sorts clause references numerically (4.1, 4.2 ... 9.1, 10.1) instead of
        // as plain text, where "10.1" would come before "4.1".
        private static string ClauseSortKey(string clause)
        {
            var parts = clause.Split('.');
            for (int i = 0; i < parts.Length; i++)
            {
                if (int.TryParse(parts[i], out var number))
                    parts[i] = number.ToString("D6");
            }
            return string.Join(".", parts);
        }
    }
}