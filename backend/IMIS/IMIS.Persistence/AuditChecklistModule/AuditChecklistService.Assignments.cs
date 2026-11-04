using IMIS.Application.AuditChecklistModule;
using IMIS.Application.IQASignatoryModule;
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
        private const string TeamLeaderRoleName = "Auditor Team Leader";

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
                        .ThenInclude(a => a!.User)
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
                        Name = AuditorName(row.Auditor!),
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
                    .Include(a => a.User)
                    .Where(a => !a.IsDeleted && extraAuditorIds.Contains(a.Id))
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
                foreach (var a in extras)
                {
                    members[a.Id] = new TeamMember { AuditorId = a.Id, Name = AuditorName(a), IsLeader = false, UserId = a.UserId };
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
                    .ThenInclude(x => x!.User)
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

                // A member of the team who holds the Auditor Team Leader role is
                // that team's leader, even when the roster's leader flag is not
                // set on them (same rule as the Audit Schedule).
                if (!isLeader && me != null &&
                    await IsInRoleAsync(userId, TeamLeaderRoleName, cancellationToken).ConfigureAwait(false))
                {
                    isLeader = true;
                    me.IsLeader = true;
                }

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

        /// <summary>
        /// The auditor's real name, from their user account. The Auditor row's own
        /// Name is only a placeholder ("Auditor 34"), so it is the fallback.
        /// </summary>
        private static string AuditorName(Auditor auditor)
        {
            var user = auditor.User;
            if (user != null)
            {
                var full = string.Join(" ", new[] { user.Prefix, user.FirstName, user.MiddleName, user.LastName, user.Suffix }
                    .Where(p => !string.IsNullOrWhiteSpace(p)));
                if (!string.IsNullOrWhiteSpace(full)) return full;
                if (!string.IsNullOrWhiteSpace(user.UserName)) return user.UserName!;
            }
            return auditor.Name;
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
                row.AssignedAuditorName = assignment.Auditor == null ? null : AuditorName(assignment.Auditor);
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
                        AssignedAuditorName = assignment?.Auditor == null ? null : AuditorName(assignment.Auditor),
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

        // ------------------------------------------------------------------
        // Questions. The checklist is written by the auditors: each one adds the
        // questions of the clauses assigned to them, picking from the library or
        // typing their own. The same question is never added twice.
        // ------------------------------------------------------------------
        private const int MaxQuestionLength = 1000;

        private static string NormalizeQuestion(string? text) =>
            string.Join(' ', (text ?? string.Empty).Split((char[]?)null, StringSplitOptions.RemoveEmptyEntries));

        private static bool SameQuestion(string? a, string? b) =>
            string.Equals(NormalizeQuestion(a), NormalizeQuestion(b), StringComparison.OrdinalIgnoreCase);

        /// <summary>Null when the user may write the questions of the clause: an Administrator, the team leader, or the clause's own auditor.</summary>
        private static string? ClauseWriteError(AssignmentContext ctx, IsoStandardAuditPlan clause)
        {
            if (ctx.CanAssign) return null;

            var assignment = ctx.Assignments.FirstOrDefault(a => a.IsoStandardId == clause.IsoStandardId);
            if (ctx.RestrictedAuditorId is int me && assignment != null && assignment.AuditorId == me)
                return null;

            return "This clause is not assigned to you.";
        }

        /// <summary>
        /// The library standards whose questions belong to a plan clause: the clause
        /// itself plus its sub-clauses, unless the plan lists sub-clauses of its own
        /// (then each of those owns its questions, as in the checklist generation).
        /// </summary>
        private async Task<List<long>> ClauseStandardIdsAsync(
            AssignmentContext ctx, IsoStandardAuditPlan clause, CancellationToken cancellationToken)
        {
            var own = clause.IsoStandard!.ClauseRef.Trim();
            var hasListedChild = ctx.PlanClauses.Any(c =>
                c.IsoStandard!.ClauseRef.Trim().StartsWith(own + ".", StringComparison.OrdinalIgnoreCase));
            if (hasListedChild) return new List<long> { clause.IsoStandardId!.Value };

            return await ExpandWithNestedStandardIdsAsync(new[] { clause }, cancellationToken).ConfigureAwait(false);
        }

        public async Task<(List<AuditChecklistLibraryQuestionDto>? Items, string? Error)> GetClauseQuestionsAsync(
            int auditScheduleId, long isoStandardId, string? userId, CancellationToken cancellationToken)
        {
            var ctx = await LoadAssignmentContextAsync(auditScheduleId, userId, cancellationToken).ConfigureAwait(false);
            if (ctx == null) return (null, "Audit schedule not found.");

            var clause = ctx.PlanClauses.FirstOrDefault(c => c.IsoStandardId == isoStandardId);
            if (clause == null) return (null, "The clause is not part of this audit plan entry.");

            var error = ClauseWriteError(ctx, clause);
            if (error != null) return (null, error);

            var standardIds = await ClauseStandardIdsAsync(ctx, clause, cancellationToken).ConfigureAwait(false);

            var inChecklist = await _dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => c.AuditScheduleId == auditScheduleId && !c.IsDeleted && c.AuditChecklistQNA != null)
                .Select(c => new { c.AuditChecklistQNAId, c.AuditChecklistQNA!.Question })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
            var usedIds = inChecklist.Select(r => r.AuditChecklistQNAId).ToHashSet();
            var usedTexts = inChecklist.Select(r => NormalizeQuestion(r.Question).ToLowerInvariant()).ToHashSet();

            var library = await _dbContext.Set<AuditChecklistQNA>()
                .AsNoTracking()
                .Include(q => q.IsoStandard)
                .Where(q => !q.IsDeleted && q.IsoStandardId != null && standardIds.Contains(q.IsoStandardId.Value))
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            var seenTexts = new HashSet<string>();
            var items = library
                .OrderBy(q => q.IsoStandard?.ClauseRef ?? string.Empty, new ClauseNumberComparer())
                .ThenBy(q => q.Id)
                .Where(q => !usedIds.Contains(q.Id))
                .Where(q =>
                {
                    var text = NormalizeQuestion(q.Question).ToLowerInvariant();
                    return !usedTexts.Contains(text) && seenTexts.Add(text);
                })
                .Select(q => new AuditChecklistLibraryQuestionDto
                {
                    Id = q.Id,
                    Question = NormalizeQuestion(q.Question),
                    ClauseRef = q.IsoStandard?.ClauseRef?.Trim() ?? string.Empty
                })
                .ToList();

            return (items, null);
        }

        public async Task<(bool Success, string? Error)> AddQuestionAsync(
            int auditScheduleId, AuditChecklistAddQuestionRequest request, string? userId, CancellationToken cancellationToken)
        {
            if (request == null) return (false, "No question was provided.");

            var ctx = await LoadAssignmentContextAsync(auditScheduleId, userId, cancellationToken).ConfigureAwait(false);
            if (ctx == null) return (false, "Audit schedule not found.");

            var clause = ctx.PlanClauses.FirstOrDefault(c => c.IsoStandardId == request.IsoStandardId);
            if (clause == null) return (false, "The clause is not part of this audit plan entry.");

            var error = ClauseWriteError(ctx, clause);
            if (error != null) return (false, error);

            var scheduleState = await IQAApprovalWorkflow.GetStateCodeAsync(
                _dbContext, IQAApprovalWorkflow.EntityTypes.AuditSchedule, auditScheduleId, cancellationToken)
                .ConfigureAwait(false);
            if (scheduleState != IQAApprovalWorkflow.StateCodes.Confirmed &&
                scheduleState != IQAApprovalWorkflow.StateCodes.Approved)
            {
                return (false, "The audit schedule must be confirmed by the Department Head (or approved) before its checklist is written.");
            }

            var entryId = await _dbContext.Set<AuditSchedule>()
                .AsNoTracking()
                .Where(s => s.Id == auditScheduleId && !s.IsDeleted)
                .Select(s => s.AuditPlanEntryId)
                .FirstOrDefaultAsync(cancellationToken)
                .ConfigureAwait(false);
            if (entryId <= 0) return (false, "Audit schedule not found.");

            var standardIds = await ClauseStandardIdsAsync(ctx, clause, cancellationToken).ConfigureAwait(false);

            AuditChecklistQNA? question;
            if (request.QuestionId is int questionId)
            {
                question = await _dbContext.Set<AuditChecklistQNA>()
                    .FirstOrDefaultAsync(q => q.Id == questionId && !q.IsDeleted, cancellationToken)
                    .ConfigureAwait(false);
                if (question?.IsoStandardId == null || !standardIds.Contains(question.IsoStandardId.Value))
                    return (false, "That question does not belong to this clause.");
            }
            else
            {
                var text = NormalizeQuestion(request.Question);
                if (text.Length == 0) return (false, "Type the question to add.");
                if (text.Length > MaxQuestionLength)
                    return (false, $"A question can have at most {MaxQuestionLength} characters.");

                // The same wording already in the library for this clause is reused.
                var sameClause = await _dbContext.Set<AuditChecklistQNA>()
                    .Where(q => !q.IsDeleted && q.IsoStandardId == clause.IsoStandardId)
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
                question = sameClause.FirstOrDefault(q => SameQuestion(q.Question, text));
                if (question == null)
                {
                    question = new AuditChecklistQNA
                    {
                        Id = 0,
                        Question = text,
                        IsoStandardId = clause.IsoStandardId
                    };
                }
            }

            var inChecklist = await _dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => c.AuditScheduleId == auditScheduleId && !c.IsDeleted && c.AuditChecklistQNA != null)
                .Select(c => new
                {
                    c.AuditChecklistQNAId,
                    c.AuditChecklistQNA!.Question,
                    ClauseRef = c.AuditChecklistQNA!.IsoStandard!.ClauseRef
                })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            // A clause has one question: reword it instead of adding another.
            if (inChecklist.Any(r => MatchPlanClause(r.ClauseRef, ctx.PlanClauses)?.IsoStandardId == clause.IsoStandardId))
                return (false, "This clause already has its question. Edit it or pick another one from its dropdown.");

            if (inChecklist.Any(r => (question.Id != 0 && r.AuditChecklistQNAId == question.Id) ||
                                     SameQuestion(r.Question, question.Question)))
            {
                return (false, "This question is already in the checklist.");
            }

            if (question.Id == 0)
                _dbContext.Set<AuditChecklistQNA>().Add(question);

            _dbContext.Set<AuditChecklist>().Add(new AuditChecklist
            {
                Id = 0,
                AuditPlanEntryId = entryId,
                AuditScheduleId = auditScheduleId,
                AuditChecklistQNA = question,
                AuditChecklistQNAId = question.Id,
                Conforming = null,
                FindingAndRemarks = null
            });

            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return (true, null);
        }

        public async Task<(bool Success, string? Error)> RemoveQuestionAsync(
            int auditScheduleId, int checklistId, string? userId, CancellationToken cancellationToken)
        {
            var ctx = await LoadAssignmentContextAsync(auditScheduleId, userId, cancellationToken).ConfigureAwait(false);
            if (ctx == null) return (false, "Audit schedule not found.");

            var row = await _dbContext.Set<AuditChecklist>()
                .Include(c => c.AuditChecklistQNA)
                    .ThenInclude(q => q!.IsoStandard)
                .FirstOrDefaultAsync(c => c.Id == checklistId && c.AuditScheduleId == auditScheduleId && !c.IsDeleted,
                    cancellationToken)
                .ConfigureAwait(false);
            if (row == null) return (false, "Checklist question not found.");

            var clause = MatchPlanClause(row.AuditChecklistQNA?.IsoStandard?.ClauseRef, ctx.PlanClauses);
            var error = clause != null
                ? ClauseWriteError(ctx, clause)
                : (ctx.CanAssign ? null : "This question is not part of a clause assigned to you.");
            if (error != null) return (false, error);

            if (row.Conforming != null || !string.IsNullOrWhiteSpace(row.FindingAndRemarks))
                return (false, "Clear the answer and the remarks of this question first, then remove it.");

            row.IsDeleted = true;
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return (true, null);
        }

        /// <summary>
        /// An auditor may reword a question in the table. The shared library
        /// question is never edited (other schedules use it): the row is pointed at
        /// the library question of the same clause with that wording, or at a new
        /// one. Returns an error message, or null when the row is fine to save.
        /// </summary>
        private async Task<string?> ApplyQuestionEditAsync(AuditChecklistDto dto, CancellationToken cancellationToken)
        {
            if (dto.Id <= 0 || dto.ItemsAndQuestions == null) return null;

            var stored = await _dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => c.Id == dto.Id && !c.IsDeleted)
                .Select(c => new
                {
                    c.AuditScheduleId,
                    c.AuditChecklistQNAId,
                    Question = c.AuditChecklistQNA!.Question,
                    IsoStandardId = c.AuditChecklistQNA!.IsoStandardId
                })
                .FirstOrDefaultAsync(cancellationToken)
                .ConfigureAwait(false);
            if (stored == null) return "Checklist item not found.";

            // The link to the library question is the server's to decide, not the client's.
            dto.AuditChecklistQNAId = stored.AuditChecklistQNAId;

            var text = NormalizeQuestion(dto.ItemsAndQuestions);
            if (SameQuestion(text, stored.Question))
            {
                dto.ItemsAndQuestions = stored.Question;
                return null;
            }

            if (text.Length == 0) return "The question cannot be empty.";
            if (text.Length > MaxQuestionLength)
                return $"A question can have at most {MaxQuestionLength} characters.";

            var others = await _dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => c.AuditScheduleId == stored.AuditScheduleId && c.Id != dto.Id &&
                            !c.IsDeleted && c.AuditChecklistQNA != null)
                .Select(c => c.AuditChecklistQNA!.Question)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
            if (others.Any(q => SameQuestion(q, text)))
                return "This question is already in the checklist.";

            var sameClause = await _dbContext.Set<AuditChecklistQNA>()
                .Where(q => !q.IsDeleted && q.IsoStandardId == stored.IsoStandardId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
            var question = sameClause.FirstOrDefault(q => SameQuestion(q.Question, text));
            if (question == null)
            {
                question = new AuditChecklistQNA
                {
                    Id = 0,
                    Question = text,
                    IsoStandardId = stored.IsoStandardId
                };
                _dbContext.Set<AuditChecklistQNA>().Add(question);
                await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            }

            dto.AuditChecklistQNAId = question.Id;
            dto.ItemsAndQuestions = NormalizeQuestion(question.Question);
            return null;
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
                var editError = await ApplyQuestionEditAsync(dto, cancellationToken).ConfigureAwait(false);
                if (editError != null) return (false, editError);

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

            var questionError = await ApplyQuestionEditAsync(dto, cancellationToken).ConfigureAwait(false);
            if (questionError != null) return (false, questionError);

            entity.AuditChecklistQNAId = dto.AuditChecklistQNAId;
            entity.Conforming = dto.Conforming;
            entity.FindingAndRemarks = dto.FindingAndRemarks;
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            dto.AuditeeId = entity.AuditeeId;
            dto.Auditees = entity.Auditees;
            return (true, null);
        }
    }
}
