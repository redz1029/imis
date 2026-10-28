using IMIS.Application.AuditChecklistModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditChecklistModule
{
    /// <summary>
    /// Clause assignment: the Auditor Team Leader divides the clauses of the
    /// audit plan entry among the auditors of the team; an auditor only sees and
    /// answers the checklist rows of the clauses assigned to them.
    /// </summary>
    public partial class AuditChecklistService
    {
        private const string AdministratorRoleName = "Administrator";

        private sealed class TeamMember
        {
            public int AuditorId { get; init; }
            public string Name { get; init; } = string.Empty;
            public bool IsLeader { get; set; }
            public string? UserId { get; init; }
        }

        private sealed class AssignmentContext
        {
            public int? TeamId { get; init; }
            public string? TeamName { get; init; }
            public List<IsoStandardAuditPlan> PlanClauses { get; init; } = new();
            public List<TeamMember> Members { get; init; } = new();
            public List<AuditChecklistClauseAssignment> Assignments { get; init; } = new();
            public bool IsAdmin { get; init; }
            public bool IsLeader { get; init; }

            /// <summary>Set when the caller is a plain auditor of the team: they are restricted to their own clauses.</summary>
            public int? RestrictedAuditorId { get; init; }

            public bool CanAssign => IsAdmin || IsLeader;
        }

        private async Task<AssignmentContext?> LoadAssignmentContextAsync(
            int auditScheduleId, string? userId, CancellationToken cancellationToken)
        {
            var schedule = await _dbContext.Set<AuditSchedule>()
                .AsNoTracking()
                .Include(s => s.Team)
                .Include(s => s.AuditPlanEntry!)
                    .ThenInclude(e => e!.IsoAuditors)
                .Include(s => s.AuditPlanEntry!)
                    .ThenInclude(e => e!.IsoStandardAuditPlans)
                        .ThenInclude(sp => sp.IsoStandard)
                .AsSplitQuery()
                .FirstOrDefaultAsync(s => s.Id == auditScheduleId && !s.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
            if (schedule == null) return null;

            var entry = schedule.AuditPlanEntry;
            var entryAuditors = (entry?.IsoAuditors ?? new List<IsoAuditor>())
                .Where(a => !a.IsDeleted)
                .ToList();

            // Audit team: assigned on the schedule, otherwise the team of the
            // entry's ISO auditors (same rule as the checklist list).
            var teamId = schedule.TeamId ?? entryAuditors.FirstOrDefault(a => a.TeamId != null)?.TeamId;
            var teamName = schedule.Team?.Name;
            if (teamName == null && teamId.HasValue)
            {
                teamName = await _dbContext.Set<Team>()
                    .AsNoTracking()
                    .Where(t => t.Id == teamId.Value)
                    .Select(t => t.Name)
                    .FirstOrDefaultAsync(cancellationToken)
                    .ConfigureAwait(false);
            }

            // Members: the team roster plus the auditors named on the entry.
            var members = new Dictionary<int, TeamMember>();
            if (teamId.HasValue)
            {
                var roster = await _dbContext.Set<AuditorTeams>()
                    .AsNoTracking()
                    .Include(t => t.Auditor)
                    .Where(t => !t.IsDeleted && t.TeamId == teamId.Value && t.AuditorId != null && t.Auditor != null)
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
                foreach (var row in roster)
                {
                    var auditorId = row.AuditorId!.Value;
                    if (members.TryGetValue(auditorId, out var existingMember))
                    {
                        existingMember.IsLeader |= row.IsTeamLeader;
                        continue;
                    }
                    members[auditorId] = new TeamMember
                    {
                        AuditorId = auditorId,
                        Name = row.Auditor!.Name,
                        IsLeader = row.IsTeamLeader,
                        UserId = row.Auditor.UserId
                    };
                }
            }

            var extraAuditorIds = entryAuditors
                .Where(a => a.AuditorId != null && !members.ContainsKey(a.AuditorId.Value))
                .Select(a => a.AuditorId!.Value)
                .Distinct()
                .ToList();
            if (extraAuditorIds.Count > 0)
            {
                var extras = await _dbContext.Set<Auditor>()
                    .AsNoTracking()
                    .Where(a => !a.IsDeleted && extraAuditorIds.Contains(a.Id))
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
                foreach (var a in extras)
                {
                    members[a.Id] = new TeamMember { AuditorId = a.Id, Name = a.Name, IsLeader = false, UserId = a.UserId };
                }
            }

            var planClauses = (entry?.IsoStandardAuditPlans ?? new List<IsoStandardAuditPlan>())
                .Where(sp => !sp.IsDeleted && sp.IsoStandardId != null && sp.IsoStandard != null &&
                             !string.IsNullOrWhiteSpace(sp.IsoStandard.ClauseRef))
                .GroupBy(sp => sp.IsoStandardId!.Value)
                .Select(g => g.First())
                .ToList();

            var assignments = await _dbContext.Set<AuditChecklistClauseAssignment>()
                .AsNoTracking()
                .Include(a => a.Auditor)
                .Where(a => a.AuditScheduleId == auditScheduleId && !a.IsDeleted)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            var isAdmin = false;
            var isLeader = false;
            int? restrictedAuditorId = null;
            if (!string.IsNullOrWhiteSpace(userId))
            {
                isAdmin = await IsInRoleAsync(userId, AdministratorRoleName, cancellationToken).ConfigureAwait(false);
                var me = members.Values.FirstOrDefault(m => m.UserId == userId);
                isLeader = me?.IsLeader ?? false;
                if (!isAdmin && !isLeader && me != null)
                    restrictedAuditorId = me.AuditorId;
            }

            return new AssignmentContext
            {
                TeamId = teamId,
                TeamName = teamName,
                PlanClauses = planClauses,
                Members = members.Values.ToList(),
                Assignments = assignments,
                IsAdmin = isAdmin,
                IsLeader = isLeader,
                RestrictedAuditorId = restrictedAuditorId
            };
        }

        private Task<bool> IsInRoleAsync(string userId, string roleName, CancellationToken cancellationToken)
        {
            return (from ur in _dbContext.Set<IdentityUserRole<string>>()
                    join r in _dbContext.Set<IdentityRole>() on ur.RoleId equals r.Id
                    where ur.UserId == userId && r.Name == roleName
                    select ur.UserId).AnyAsync(cancellationToken);
        }

        /// <summary>
        /// The plan clause a checklist row belongs to: the most specific plan
        /// clause equal to, or a parent of, the row's clause (same prefix rule
        /// the checklist generation uses to pull sub-clause questions).
        /// </summary>
        private static IsoStandardAuditPlan? MatchPlanClause(string? rowClauseRef, IEnumerable<IsoStandardAuditPlan> planClauses)
        {
            if (string.IsNullOrWhiteSpace(rowClauseRef)) return null;
            var rowRef = rowClauseRef.Trim();

            return planClauses
                .Where(c =>
                {
                    var planRef = c.IsoStandard!.ClauseRef.Trim();
                    return string.Equals(rowRef, planRef, StringComparison.OrdinalIgnoreCase) ||
                           rowRef.StartsWith(planRef + ".", StringComparison.OrdinalIgnoreCase);
                })
                .OrderByDescending(c => c.IsoStandard!.ClauseRef.Trim().Length)
                .FirstOrDefault();
        }

        public async Task<IEnumerable<AuditChecklistDto>> GetOrGenerateForAuditScheduleAsync(
            int auditScheduleId, CancellationToken cancellationToken, string? userId = null)
        {
            var rows = (await GetOrGenerateRowsForAuditScheduleAsync(auditScheduleId, cancellationToken).ConfigureAwait(false)).ToList();
            if (rows.Count == 0) return rows;

            var ctx = await LoadAssignmentContextAsync(auditScheduleId, userId, cancellationToken).ConfigureAwait(false);
            if (ctx == null) return rows;

            foreach (var row in rows)
            {
                var clause = MatchPlanClause(row.Criteria, ctx.PlanClauses);
                if (clause == null) continue;

                row.PlanClauseId = clause.IsoStandardId;
                var assignment = ctx.Assignments.FirstOrDefault(a => a.IsoStandardId == clause.IsoStandardId);
                if (assignment == null) continue;

                row.AssignedAuditorId = assignment.AuditorId;
                row.AssignedAuditorName = assignment.Auditor?.Name;
            }

            if (ctx.RestrictedAuditorId is int auditorId)
                rows = rows.Where(r => r.AssignedAuditorId == auditorId).ToList();

            await AttachNcarsAsync(rows, cancellationToken).ConfigureAwait(false);
            return rows;
        }

        public async Task<AuditChecklistAssignmentsDto> GetAssignmentsAsync(
            int auditScheduleId, string? userId, CancellationToken cancellationToken)
        {
            var ctx = await LoadAssignmentContextAsync(auditScheduleId, userId, cancellationToken).ConfigureAwait(false);
            if (ctx == null)
                throw new KeyNotFoundException("Audit schedule not found.");

            var rowInfo = await _dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => c.AuditScheduleId == auditScheduleId && !c.IsDeleted)
                .Select(c => new
                {
                    ClauseRef = c.AuditChecklistQNA!.IsoStandard!.ClauseRef,
                    Answered = c.Conforming != null
                })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            var rowClauseIds = rowInfo
                .Select(r => new { ClauseId = MatchPlanClause(r.ClauseRef, ctx.PlanClauses)?.IsoStandardId, r.Answered })
                .ToList();

            var clauses = ctx.PlanClauses
                .OrderBy(c => c.IsoStandard!.ClauseRef, new ClauseNumberComparer())
                .Select(c =>
                {
                    var assignment = ctx.Assignments.FirstOrDefault(a => a.IsoStandardId == c.IsoStandardId);
                    var mine = rowClauseIds.Where(r => r.ClauseId == c.IsoStandardId).ToList();
                    return new AuditChecklistClauseAssignmentDto
                    {
                        IsoStandardId = c.IsoStandardId!.Value,
                        ClauseRef = c.IsoStandard!.ClauseRef.Trim(),
                        Particulars = c.IsoStandard.Particulars,
                        AssignedAuditorId = assignment?.AuditorId,
                        AssignedAuditorName = assignment?.Auditor?.Name,
                        QuestionCount = mine.Count,
                        AnsweredCount = mine.Count(r => r.Answered)
                    };
                })
                .ToList();

            var auditors = ctx.Members
                .OrderByDescending(m => m.IsLeader)
                .ThenBy(m => m.Name)
                .Select(m =>
                {
                    var theirs = clauses.Where(c => c.AssignedAuditorId == m.AuditorId).ToList();
                    return new AuditChecklistAuditorDto
                    {
                        AuditorId = m.AuditorId,
                        Name = m.Name,
                        IsTeamLeader = m.IsLeader,
                        AssignedClauseCount = theirs.Count,
                        QuestionCount = theirs.Sum(c => c.QuestionCount),
                        AnsweredCount = theirs.Sum(c => c.AnsweredCount)
                    };
                })
                .ToList();

            // An auditor only gets their own clauses.
            if (ctx.RestrictedAuditorId is int me)
            {
                clauses = clauses.Where(c => c.AssignedAuditorId == me).ToList();
                auditors = auditors.Where(a => a.AuditorId == me).ToList();
            }

            return new AuditChecklistAssignmentsDto
            {
                AuditScheduleId = auditScheduleId,
                TeamId = ctx.TeamId,
                TeamName = ctx.TeamName,
                CanAssign = ctx.CanAssign,
                OwnClausesOnly = ctx.RestrictedAuditorId.HasValue,
                Clauses = clauses,
                Auditors = auditors
            };
        }

        public async Task<(bool Success, string? Error)> AssignClausesAsync(
            int auditScheduleId, IReadOnlyList<AuditChecklistAssignmentRequestItem> assignments,
            string? userId, CancellationToken cancellationToken)
        {
            if (assignments == null || assignments.Count == 0)
                return (false, "No clause assignments were provided.");

            var ctx = await LoadAssignmentContextAsync(auditScheduleId, userId, cancellationToken).ConfigureAwait(false);
            if (ctx == null)
                return (false, "Audit schedule not found.");

            if (!ctx.CanAssign)
                return (false, "Only the Auditor Team Leader of this audit team can assign clauses.");

            if (!ctx.TeamId.HasValue || ctx.Members.Count == 0)
                return (false, "This audit schedule has no audit team with auditors to assign clauses to.");

            var requested = new Dictionary<long, int?>();
            foreach (var item in assignments)
            {
                if (!ctx.PlanClauses.Any(c => c.IsoStandardId == item.IsoStandardId))
                    return (false, "A selected clause is not part of this audit plan entry.");

                if (item.AuditorId.HasValue && !ctx.Members.Any(m => m.AuditorId == item.AuditorId.Value))
                    return (false, "A clause can only be assigned to an auditor of this audit team.");

                if (requested.TryGetValue(item.IsoStandardId, out var previous) && previous != item.AuditorId)
                    return (false, "A clause can only be assigned to one auditor.");

                requested[item.IsoStandardId] = item.AuditorId;
            }

            var tracked = await _dbContext.Set<AuditChecklistClauseAssignment>()
                .Where(a => a.AuditScheduleId == auditScheduleId && !a.IsDeleted)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            var now = DateTime.UtcNow;
            foreach (var (isoStandardId, auditorId) in requested)
            {
                var current = tracked.FirstOrDefault(a => a.IsoStandardId == isoStandardId);

                if (!auditorId.HasValue)
                {
                    if (current != null) current.IsDeleted = true;
                    continue;
                }

                if (current != null)
                {
                    current.AuditorId = auditorId.Value;
                    current.AssignedByUserId = userId;
                    current.AssignedDate = now;
                    continue;
                }

                _dbContext.Set<AuditChecklistClauseAssignment>().Add(new AuditChecklistClauseAssignment
                {
                    Id = 0,
                    AuditScheduleId = auditScheduleId,
                    IsoStandardId = isoStandardId,
                    AuditorId = auditorId.Value,
                    AssignedByUserId = userId,
                    AssignedDate = now
                });
            }

            try
            {
                await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            }
            catch (DbUpdateConcurrencyException)
            {
                return (false, "The assignments were changed by someone else. Please refresh and try again.");
            }

            return (true, null);
        }

        private async Task<(bool Success, string? Error)> SaveChecklistRowForUserAsync(
            AuditChecklistDto dto, string? userId, CancellationToken cancellationToken)
        {
            var scheduleId = dto.AuditScheduleId;
            string? rowClauseRef = null;
            var isExisting = dto.Id > 0;

            if (isExisting)
            {
                var stored = await _dbContext.Set<AuditChecklist>()
                    .AsNoTracking()
                    .Where(c => c.Id == dto.Id && !c.IsDeleted)
                    .Select(c => new
                    {
                        c.AuditScheduleId,
                        ClauseRef = c.AuditChecklistQNA!.IsoStandard!.ClauseRef
                    })
                    .FirstOrDefaultAsync(cancellationToken)
                    .ConfigureAwait(false);
                if (stored == null)
                    return (false, "Checklist item not found.");

                // Trust the stored row, never the client, for which schedule it is.
                scheduleId = stored.AuditScheduleId;
                rowClauseRef = stored.ClauseRef;
            }

            var ctx = await LoadAssignmentContextAsync(scheduleId, userId, cancellationToken).ConfigureAwait(false);

            // Team Leader, Administrator and every non-auditor role: unchanged behavior.
            if (ctx?.RestrictedAuditorId is not int auditorId)
            {
                var saved = await SaveChecklistAsync(dto, cancellationToken).ConfigureAwait(false);
                return saved ? (true, null) : (false, "Checklist item not found.");
            }

            if (!isExisting)
                return (false, "Only the Auditor Team Leader can add checklist items.");

            var clause = MatchPlanClause(rowClauseRef, ctx.PlanClauses);
            var assignment = clause == null
                ? null
                : ctx.Assignments.FirstOrDefault(a => a.IsoStandardId == clause.IsoStandardId);
            if (assignment == null || assignment.AuditorId != auditorId)
                return (false, "This clause is not assigned to you.");

            // An auditor only answers their rows: nothing else is writable.
            var entity = await _dbContext.Set<AuditChecklist>()
                .FirstOrDefaultAsync(c => c.Id == dto.Id && !c.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
            if (entity == null)
                return (false, "Checklist item not found.");

            entity.Conforming = dto.Conforming;
            entity.FindingAndRemarks = dto.FindingAndRemarks;
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            dto.AuditeeId = entity.AuditeeId;
            dto.Auditees = entity.Auditees;
            return (true, null);
        }
    }
}
