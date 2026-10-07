using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditChecklistModule;
using IMIS.Application.AuditChecklistQNAModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.IQASignatoryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditChecklistModule
{
    public class AuditChecklistService : IAuditChecklistService
    {
        private readonly IAuditChecklistRepository _repository;
        private readonly IAuditChecklistQNARepository _qnaRepository;
        private readonly ImisDbContext _dbContext;

        public AuditChecklistService(
            IAuditChecklistRepository repository,
            IAuditChecklistQNARepository qnaRepository,
            ImisDbContext dbContext)
        {
            _repository = repository;
            _qnaRepository = qnaRepository;
            _dbContext = dbContext;
        }

        public async Task<AuditChecklistDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new AuditChecklistDto(entity);
        }

        /// <summary>
        /// The CHECKLIST LIST SOURCE OF TRUTH. Dynamically generated from the
        /// Audit Schedule records (in their natural Id order), restricted to
        /// schedules that have reached the CONFIRMED (or APPROVED) workflow
        /// state. For each confirmed schedule the department/office, ISO
        /// clauses and audit team are resolved from the schedule's Audit Plan
        /// Entry and mapped into the checklist summary. Schedules without any
        /// ISO clauses are skipped because a checklist cannot be generated
        /// without them. There is no hardcoded team roster anywhere.
        /// </summary>
        public async Task<List<AuditChecklistSummaryDto>> GetSchedulesWithChecklistDataAsync(CancellationToken cancellationToken)
        {
            // 1) All real, usable audit schedules (in their natural Id order =
            //    schedule order) with every association the checklist needs.
            var schedules = await _dbContext.Set<AuditSchedule>()
                .AsNoTracking()
                .Where(s => !s.IsDeleted && s.AuditPlanEntryId > 0)
                .OrderBy(s => s.Id)
                .Include(s => s.Team)
                .Include(s => s.IQASignatories)
                    .ThenInclude(sig => sig.IQASignatoryTemplate)
                .Include(s => s.AuditableOffices!)
                    .ThenInclude(ao => ao.Office)
                .Include(s => s.AuditPlanEntry!)
                    .ThenInclude(e => e!.AuditPlanProcesses)
                        .ThenInclude(p => p.Office)
                .Include(s => s.AuditPlanEntry!)
                    .ThenInclude(e => e!.IsoAuditors)
                        .ThenInclude(a => a.Team)
                .Include(s => s.AuditPlanEntry!)
                    .ThenInclude(e => e!.IsoStandardAuditPlans)
                        .ThenInclude(sp => sp.IsoStandard)
                .Include(s => s.AuditPlan)
                    .ThenInclude(p => p!.AuditProgramme)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            // 2) Count existing checklist rows per schedule (no correlated
            //    subquery — one bulk lookup).
            var checklistCounts = await _dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => !c.IsDeleted)
                .GroupBy(c => c.AuditScheduleId)
                .Select(g => new { AuditScheduleId = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.AuditScheduleId, x => x.Count, cancellationToken)
                .ConfigureAwait(false);

            var result = new List<AuditChecklistSummaryDto>();
            foreach (var s in schedules)
            {
                // Gate on the workflow: only a CONFIRMED (or APPROVED) schedule
                // may expose a generated checklist.
                var stateCode = IQAApprovalWorkflow.DeriveStateCode(
                    s.IQASignatories, IQAApprovalWorkflow.EntityTypes.AuditSchedule);

                if (stateCode != IQAApprovalWorkflow.StateCodes.Confirmed &&
                    stateCode != IQAApprovalWorkflow.StateCodes.Approved)
                {
                    continue;
                }

                // Department / office: the explicit AuditableOffices link
                // first, otherwise the Audit Plan Entry's processes (where
                // auto-created schedules carry their office).
                string? officeProcess = null;
                var officeNames = (s.AuditableOffices ?? new List<AuditableOffices>())
                    .Select(ao => ao.Office?.Name)
                    .Where(n => !string.IsNullOrWhiteSpace(n))
                    .Select(n => n!)
                    .Distinct()
                    .ToList();

                if (officeNames.Any())
                {
                    officeProcess = string.Join(", ", officeNames);
                }
                else if (s.AuditPlanEntry?.AuditPlanProcesses?.Any() == true)
                {
                    officeProcess = string.Join(", ", s.AuditPlanEntry.AuditPlanProcesses
                        .Select(p => p.Office?.Name ?? p.ProcessName)
                        .Where(n => !string.IsNullOrWhiteSpace(n)));
                }

                // ISO clauses are REQUIRED — without them there is no checklist.
                var clauseCount = s.AuditPlanEntry?.IsoStandardAuditPlans?
                    .Count(sp => !sp.IsDeleted) ?? 0;
                if (clauseCount == 0) continue;

                // Audit team: assigned on the schedule, otherwise the team on
                // the entry's ISO auditors. The team is display-only, so a
                // missing team never hides an otherwise valid confirmed
                // schedule — the checklist is driven by the ISO clauses.
                Team? team = s.Team;
                int? teamId = s.TeamId;
                if (team == null && s.AuditPlanEntry?.IsoAuditors != null)
                {
                    var isoTeam = s.AuditPlanEntry.IsoAuditors
                        .FirstOrDefault(a => a.Team != null)?.Team;
                    if (isoTeam != null)
                    {
                        team = isoTeam;
                        teamId = isoTeam.Id;
                    }
                }

                string? scope = s.AuditPlan?.AuditProgramme?.ScopeOfAudit
                    ?? s.AuditPlan?.AuditProgramme?.ScopeAndFreqAudit
                    ?? s.AuditPlan?.PlanName;

                result.Add(new AuditChecklistSummaryDto
                {
                    AuditScheduleId = s.Id,
                    TeamId = teamId,
                    TeamName = team?.Name,
                    OfficeProcess = string.IsNullOrWhiteSpace(officeProcess) ? null : officeProcess,
                    AuditScope = string.IsNullOrWhiteSpace(scope) ? null : scope.Trim(),
                    AuditorNames = team?.Name,
                    Auditees = null,
                    ClauseCount = clauseCount,
                    // Surface the real workflow status (Confirmed / Approved)
                    // so the UI can label the active checklist correctly.
                    StatusName = IQAApprovalWorkflow.StateName(
                        stateCode, IQAApprovalWorkflow.EntityTypes.AuditSchedule)
                });
            }

            return result;
        }

        /// <summary>
        /// Get-or-generate checklist rows driven by the UNIQUE AuditScheduleId
        /// (the only reliable key for the whole flow). If checklist rows
        /// already exist for the schedule they are returned untouched —
        /// existing Conforming / FindingAndRemarks are preserved, no new
        /// duplicate rows are created. Otherwise the rows are generated from
        /// the schedule's AuditPlanEntry ISO clauses.
        /// </summary>
        public async Task<IEnumerable<AuditChecklistDto>> GetOrGenerateForAuditScheduleAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            var existing = (await _repository.GetByAuditScheduleIdWithScheduleAsync(auditScheduleId, cancellationToken).ConfigureAwait(false)).ToList();
            if (existing.Any())
            {
                return existing
                    .Select(x => new AuditChecklistDto(x))
                    .OrderBy(d => d.Criteria ?? string.Empty, new ClauseNumberComparer());
            }

            var schedule = await _dbContext.Set<AuditSchedule>()
                .AsNoTracking()
                .Include(s => s.Team)
                .Include(s => s.AuditableOffices!)
                    .ThenInclude(ao => ao.Office)
                .Include(s => s.AuditPlan!)
                    .ThenInclude(p => p.AuditProgramme)
                .Include(s => s.AuditPlanEntry!)
                    .ThenInclude(e => e!.AuditPlanProcesses)
                        .ThenInclude(p => p.Office)
                .Include(s => s.AuditPlanEntry!)
                    .ThenInclude(e => e!.IsoAuditors)
                        .ThenInclude(a => a.Team)
                .Include(s => s.AuditPlanEntry!)
                    .ThenInclude(e => e!.IsoStandardAuditPlans)
                        .ThenInclude(sp => sp.IsoStandard)
                .FirstOrDefaultAsync(s => s.Id == auditScheduleId && !s.IsDeleted, cancellationToken)
                .ConfigureAwait(false);

            if (schedule == null)
            {
                throw new KeyNotFoundException($"Audit schedule not found.");
            }

            // Auto-generation only kicks in once the schedule is CONFIRMED
            // (or APPROVED). Existing rows were already returned above, so a
            // saved checklist is never blocked by a later status change.
            var scheduleState = await IQAApprovalWorkflow.GetStateCodeAsync(
                _dbContext, IQAApprovalWorkflow.EntityTypes.AuditSchedule, auditScheduleId, cancellationToken)
                .ConfigureAwait(false);

            if (scheduleState != IQAApprovalWorkflow.StateCodes.Confirmed &&
                scheduleState != IQAApprovalWorkflow.StateCodes.Approved)
            {
                throw new InvalidOperationException(
                    $"Audit Schedule #{auditScheduleId} is in status '{IQAApprovalWorkflow.StateName(scheduleState, IQAApprovalWorkflow.EntityTypes.AuditSchedule)}'. " +
                    "A schedule must be confirmed by the Department Head (or approved) before generating its checklist.");
            }

            var entry = schedule.AuditPlanEntry;
            if (entry?.IsoStandardAuditPlans == null || !entry.IsoStandardAuditPlans.Any())
            {
                return Enumerable.Empty<AuditChecklistDto>();
            }

            // Expand the assigned clauses to every nested sub-clause
            // (matched by ClauseRef prefix). The QNA library is keyed to
            // specific standards, so a parent assignment like "4" or "4.4"
            // would otherwise silently yield zero questions.
            var standardIds = await ExpandWithNestedStandardIdsAsync(
                entry.IsoStandardAuditPlans ?? Enumerable.Empty<IsoStandardAuditPlan>(),
                cancellationToken).ConfigureAwait(false);

            var questionsById = new Dictionary<int, (AuditChecklistQNA Question, string ClauseRef)>();
            foreach (var stdId in standardIds)
            {
                var rawQuestions = await _qnaRepository.GetByIsoStandardIdAsync(stdId, cancellationToken).ConfigureAwait(false);
                foreach (var q in rawQuestions.OfType<AuditChecklistQNA>())
                {
                    if (!questionsById.ContainsKey(q.Id))
                        questionsById[q.Id] = (q, q.IsoStandard?.ClauseRef ?? string.Empty);
                }
            }

            var newRows = new List<(AuditChecklist Row, string ClauseRef)>();
            foreach (var kv in questionsById.Values)
            {
                newRows.Add((new AuditChecklist
                {
                    Id = 0,
                    AuditPlanEntryId = entry.Id,
                    AuditScheduleId = schedule.Id,
                    AuditChecklistQNAId = kv.Question.Id,
                    Conforming = null,
                    FindingAndRemarks = null
                }, kv.ClauseRef));
            }

            // Logical/numeric clause ordering (4.1 < 4.2 < ... < 10.3) — never
            // alphabetical string sorting.
            newRows = newRows
                .OrderBy(t => t.ClauseRef, new ClauseNumberComparer())
                .ToList();

            foreach (var (row, _) in newRows)
            {
                _repository.Add(row);
            }

            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            var saved = await _repository.GetByAuditScheduleIdWithScheduleAsync(auditScheduleId, cancellationToken).ConfigureAwait(false);
            // Re-sort the returned rows the same numeric way so the form always
            // prints clauses in logical order.
            return saved
                .Select(x => new AuditChecklistDto(x))
                .OrderBy(d => d.Criteria ?? string.Empty, new ClauseNumberComparer());
        }

        /// <summary>
        /// Expands explicitly assigned ISO standard ids to include every
        /// standard nested under an assigned clause. Matching is done by
        /// ClauseRef prefix (e.g. assigning "4" also covers "4.1", "4.2",
        /// ... "4.4.1.b"; assigning "4.4" covers "4.4.1", "4.4.2", ...), so a
        /// parent-clause assignment still resolves to the QNA questions keyed
        /// to its sub-clauses. Prefix matching is used deliberately instead of
        /// the ParentID tree because the seeded ParentID links are unreliable
        /// (they even contain a cycle, which a tree walk would never
        /// terminate on without guards).
        /// </summary>
        private async Task<List<long>> ExpandWithNestedStandardIdsAsync(
            IEnumerable<IsoStandardAuditPlan> links,
            CancellationToken cancellationToken)
        {
            var assignedIds = links
                .Select(s => s.IsoStandardId)
                .Where(id => id != null)
                .Select(id => id!.Value)
                .Distinct()
                .ToList();

            var assignedRefs = links
                .Select(s => s.IsoStandard?.ClauseRef)
                .Where(c => !string.IsNullOrWhiteSpace(c))
                .Select(c => c!.Trim())
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();

            // Fall back to a lookup for links whose IsoStandard nav wasn't loaded.
            var missingIds = assignedIds
                .Where(id => !links.Any(s => s.IsoStandardId == id && s.IsoStandard != null))
                .ToList();
            if (missingIds.Count > 0)
            {
                var refById = await _dbContext.Set<IsoStandard>()
                    .AsNoTracking()
                    .Where(s => missingIds.Contains(s.Id))
                    .ToDictionaryAsync(s => s.Id, s => s.ClauseRef, cancellationToken)
                    .ConfigureAwait(false);
                foreach (var kv in refById)
                {
                    if (!string.IsNullOrWhiteSpace(kv.Value)
                        && !assignedRefs.Contains(kv.Value.Trim(), StringComparer.OrdinalIgnoreCase))
                        assignedRefs.Add(kv.Value.Trim());
                }
            }

            var expanded = new HashSet<long>(assignedIds);
            if (assignedRefs.Count > 0)
            {
                var all = await _dbContext.Set<IsoStandard>()
                    .AsNoTracking()
                    .Select(s => new { s.Id, s.ClauseRef })
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
                foreach (var a in assignedRefs)
                {
                    foreach (var s in all)
                    {
                        if (string.IsNullOrWhiteSpace(s.ClauseRef)) continue;
                        var c = s.ClauseRef.Trim();
                        if (string.Equals(c, a, StringComparison.OrdinalIgnoreCase)
                            || c.StartsWith(a + ".", StringComparison.OrdinalIgnoreCase))
                            expanded.Add(s.Id);
                    }
                }
            }
            return expanded.ToList();
        }

        public async Task<object?> GetByProcessIdAsync(int processId, CancellationToken cancellationToken)
        {
            var checklists = await _repository.GetByProcessIdAsync(processId, cancellationToken).ConfigureAwait(false);
            return checklists.Select(x => new AuditChecklistDto(x));
        }

        public async Task<IEnumerable<AuditChecklistDto>> GetOrGenerateForAuditPlanEntryAsync(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            var existing = (await _repository.GetByAuditPlanEntryIdAsync(auditPlanEntryId, cancellationToken).ConfigureAwait(false)).ToList();
            if (existing.Any())
            {
                return existing
                    .Select(x => new AuditChecklistDto(x))
                    .OrderBy(d => d.Criteria ?? string.Empty, new ClauseNumberComparer());
            }

            // Gating Rule: Verify that the Audit Schedule exists and has been Confirmed/Approved
            var schedule = await _dbContext.Set<AuditSchedule>()
                .Where(s => s.AuditPlanEntryId == auditPlanEntryId && !s.IsDeleted)
                .Select(s => new { s.Id, s.AuditPlanId })
                .FirstOrDefaultAsync(cancellationToken)
                .ConfigureAwait(false);

            if (schedule == null)
            {
                throw new InvalidOperationException(
                    $"No Audit Schedule exists for Audit Plan Entry {auditPlanEntryId}. " +
                    "A schedule must be created and confirmed for this entry before its checklist can be generated.");
            }

            var scheduleState = await IQAApprovalWorkflow.GetStateCodeAsync(
                _dbContext, IQAApprovalWorkflow.EntityTypes.AuditSchedule, schedule.Id, cancellationToken);

            if (scheduleState != IQAApprovalWorkflow.StateCodes.Confirmed &&
                scheduleState != IQAApprovalWorkflow.StateCodes.Approved)
            {
                throw new InvalidOperationException(
                    $"Audit Schedule #{schedule.Id} is in status '{IQAApprovalWorkflow.StateName(scheduleState, IQAApprovalWorkflow.EntityTypes.AuditSchedule)}'. " +
                    "A schedule must be confirmed by the Department Head (or approved) before generating its checklist.");
            }

            var entry = await _dbContext.Set<AuditPlanEntry>()
                .Include(e => e.IsoStandardAuditPlans)
                .FirstOrDefaultAsync(e => e.Id == auditPlanEntryId, cancellationToken)
                .ConfigureAwait(false);

            if (entry?.IsoStandardAuditPlans == null || !entry.IsoStandardAuditPlans.Any())
            {
                return Enumerable.Empty<AuditChecklistDto>();
            }

            // Same nested-clause expansion as the schedule path: a parent
            // assignment like "4" must also pull its sub-clause questions.
            var standardIds = await ExpandWithNestedStandardIdsAsync(
                entry.IsoStandardAuditPlans ?? Enumerable.Empty<IsoStandardAuditPlan>(),
                cancellationToken).ConfigureAwait(false);

            var questionsById = new Dictionary<int, (AuditChecklistQNA Question, string ClauseRef)>();
            foreach (var stdId in standardIds)
            {
                var rawQuestions = await _qnaRepository.GetByIsoStandardIdAsync(stdId, cancellationToken).ConfigureAwait(false);
                foreach (var q in rawQuestions.OfType<AuditChecklistQNA>())
                {
                    if (!questionsById.ContainsKey(q.Id))
                        questionsById[q.Id] = (q, q.IsoStandard?.ClauseRef ?? string.Empty);
                }
            }

            var newRows = new List<(AuditChecklist Row, string ClauseRef)>();
            foreach (var kv in questionsById.Values)
            {
                newRows.Add((new AuditChecklist
                {
                    Id = 0,
                    AuditPlanEntryId = auditPlanEntryId,
                    AuditScheduleId = schedule.Id,
                    AuditChecklistQNAId = kv.Question.Id,
                    Conforming = null,
                    FindingAndRemarks = null
                }, kv.ClauseRef));
            }

            newRows = newRows
                .OrderBy(t => t.ClauseRef, new ClauseNumberComparer())
                .ToList();

            foreach (var (row, _) in newRows)
            {
                _repository.Add(row);
            }

            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            var saved = await _repository.GetByAuditPlanEntryIdAsync(auditPlanEntryId, cancellationToken).ConfigureAwait(false);
            return saved
                .Select(x => new AuditChecklistDto(x))
                .OrderBy(d => d.Criteria ?? string.Empty, new ClauseNumberComparer());
        }

        public async Task<bool> SaveChecklistAsync(AuditChecklistDto dto, CancellationToken cancellationToken)
        {
            var entity = dto.ToEntity();

            if (entity.Id == 0)
            {
                _repository.Add(entity);
            }
            else
            {
                var existing = await _repository.GetByIdAsync(entity.Id, cancellationToken).ConfigureAwait(false);
                if (existing == null) return false;

                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task<DtoPageList<AuditChecklistDto, AuditChecklist, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<AuditChecklistDto, AuditChecklist, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return false;

            await _repository.DeleteAsync(entity, cancellationToken).ConfigureAwait(false);
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is AuditChecklistDto checklistDto)
            {
                await SaveChecklistAsync(checklistDto, cancellationToken).ConfigureAwait(false);
            }
        }

        public async Task<IEnumerable<AuditChecklistDto>> GetByAuditeeIdAsync(int auditeeId, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByAuditeeIdAsync(auditeeId, cancellationToken).ConfigureAwait(false);
            return entities.Select(x => new AuditChecklistDto(x));
        }

        public async Task<IEnumerable<AuditChecklistDto>> GetByAuditScheduleIdAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByAuditScheduleIdAsync(auditScheduleId, cancellationToken).ConfigureAwait(false);
            return entities.Select(x => new AuditChecklistDto(x));
        }
        public async Task<ReportAuditChecklistDto?> ReportGetByAuditScheduleIdAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            
            var entities = await _repository.GetByAuditScheduleIdWithScheduleAsync(auditScheduleId, cancellationToken).ConfigureAwait(false);
            var list = entities.ToList();
            return list.Any() ? new ReportAuditChecklistDto(list) : null;
        }
    }

    /// <summary>Numeric/logical ISO clause comparer (4.1 < 4.2 < ... < 10.3).</summary>
    public class ClauseNumberComparer : IComparer<string>
    {
        public int Compare(string? a, string? b)
        {
            var aParts = (a ?? "").Trim().Split('.');
            var bParts = (b ?? "").Trim().Split('.');
            var minLen = Math.Min(aParts.Length, bParts.Length);

            for (var i = 0; i < minLen; i++)
            {
                var aOk = int.TryParse(aParts[i], out var aNum);
                var bOk = int.TryParse(bParts[i], out var bNum);
                if (aOk && bOk)
                {
                    if (aNum != bNum) return aNum.CompareTo(bNum);
                }
                else
                {
                    var comp = string.Compare(aParts[i], bParts[i], StringComparison.Ordinal);
                    if (comp != 0) return comp;
                }
            }
            return aParts.Length.CompareTo(bParts.Length);
        }
    }
}
