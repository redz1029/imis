using IMIS.Domain;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.IqaNotificationModule
{
    /// <summary>
    /// Raises the IQA notifications shown in the bell. Like IQAApprovalWorkflow it
    /// works on the caller's DbContext: <see cref="AddAsync"/> only tracks the new
    /// rows, so they are saved together with the action that raised them. Where
    /// the action has already been saved, <see cref="SaveSafelyAsync"/> saves the
    /// rows on their own and can never fail the action.
    /// </summary>
    public static class IqaNotifier
    {
        public static class Entities
        {
            public const string AuditProgramme = "AuditProgramme";
            public const string AuditPlan = "AuditPlan";
            public const string AuditSchedule = "AuditSchedule";
            public const string AuditChecklist = "AuditChecklist";
            public const string AuditReport = "AuditReport";
            public const string Ncar = "Ncar";
            public const string RescheduleRequest = "RescheduleRequest";
        }

        /// <summary>The ISO sub-page index in the sidebar.</summary>
        public static class Pages
        {
            public const int Programme = 0;
            public const int Plan = 1;
            public const int Schedule = 2;
            public const int Checklist = 3;
            public const int Report = 4;
            public const int Ncar = 5;
        }

        public static class Types
        {
            public const string Submitted = "Submitted";
            public const string Resubmitted = "Resubmitted";
            public const string Approved = "Approved";
            public const string Noted = "Noted";
            public const string Confirmed = "Confirmed";
            public const string Rejected = "Rejected";
            public const string FullyApproved = "FullyApproved";
            public const string SchedulesCreated = "SchedulesCreated";
            public const string RescheduleRequested = "RescheduleRequested";
            public const string RescheduleForwarded = "RescheduleForwarded";
            public const string RescheduleApproved = "RescheduleApproved";
            public const string RescheduleRejected = "RescheduleRejected";
            public const string ClauseAssigned = "ClauseAssigned";
            public const string NcarRaised = "NcarRaised";
            public const string NcarAcknowledged = "NcarAcknowledged";
            public const string NcarResponded = "NcarResponded";
            public const string NcarApproved = "NcarApproved";
            public const string NcarVerified = "NcarVerified";
            public const string NcarClosed = "NcarClosed";
        }

        public const string TeamLeaderRoleName = "Auditor Team Leader";
        public const string LeadAuditorRoleName = "Lead Auditor";

        public static string Label(string entityType) => entityType switch
        {
            Entities.AuditProgramme => "Audit Programme",
            Entities.AuditPlan => "Audit Plan",
            Entities.AuditSchedule => "Audit Schedule",
            Entities.AuditChecklist => "Audit Checklist",
            Entities.AuditReport => "Audit Report",
            Entities.Ncar => "NCAR",
            Entities.RescheduleRequest => "Reschedule Request",
            _ => entityType
        };

        public static int PageFor(string entityType) => entityType switch
        {
            Entities.AuditProgramme => Pages.Programme,
            Entities.AuditPlan => Pages.Plan,
            Entities.AuditSchedule => Pages.Schedule,
            Entities.RescheduleRequest => Pages.Schedule,
            Entities.AuditChecklist => Pages.Checklist,
            Entities.AuditReport => Pages.Report,
            Entities.Ncar => Pages.Ncar,
            _ => Pages.Programme
        };

        private static string Trunc(string? text, int max)
        {
            var t = (text ?? string.Empty).Trim();
            return t.Length <= max ? t : t.Substring(0, max - 1) + "…";
        }

        // ------------------------------------------------------------------
        // Raising
        // ------------------------------------------------------------------

        /// <summary>
        /// Tracks one notification per distinct recipient. The actor is never
        /// notified about their own action, and a recipient who still has the
        /// same notification unread (same type, same item) is not sent it twice.
        /// Nothing is saved here.
        /// </summary>
        public static async Task AddAsync(
            DbContext db,
            IEnumerable<string?> recipients,
            string? actorUserId,
            string type,
            string title,
            string message,
            string entityType,
            long? entityId,
            int? page,
            CancellationToken ct)
        {
            var targets = (recipients ?? Enumerable.Empty<string?>())
                .Where(r => !string.IsNullOrWhiteSpace(r))
                .Select(r => r!.Trim())
                .Where(r => !string.Equals(r, actorUserId, StringComparison.OrdinalIgnoreCase))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();
            if (targets.Count == 0) return;

            var alreadyUnread = await db.Set<IqaNotification>()
                .AsNoTracking()
                .Where(n => !n.IsDeleted && n.ReadAt == null &&
                            n.Type == type && n.EntityType == entityType && n.EntityId == entityId &&
                            targets.Contains(n.RecipientUserId))
                .Select(n => n.RecipientUserId)
                .ToListAsync(ct)
                .ConfigureAwait(false);
            var skip = alreadyUnread.ToHashSet(StringComparer.OrdinalIgnoreCase);
            // ... or tracked a moment ago and not saved yet.
            foreach (var pending in db.ChangeTracker.Entries<IqaNotification>()
                         .Where(e => e.State == EntityState.Added &&
                                     e.Entity.Type == type && e.Entity.EntityType == entityType && e.Entity.EntityId == entityId))
                skip.Add(pending.Entity.RecipientUserId);

            foreach (var recipient in targets.Where(t => !skip.Contains(t)))
            {
                db.Set<IqaNotification>().Add(new IqaNotification
                {
                    Id = 0,
                    RecipientUserId = recipient,
                    ActorUserId = string.IsNullOrWhiteSpace(actorUserId) ? null : actorUserId,
                    Type = Trunc(type, 50),
                    Title = Trunc(title, 200),
                    Message = Trunc(message, 1000),
                    EntityType = Trunc(entityType, 50),
                    EntityId = entityId,
                    TargetPage = page ?? PageFor(entityType),
                    CreatedAt = DateTime.UtcNow
                });
            }
        }

        /// <summary>
        /// Saves tracked notifications after the action that raised them was
        /// already saved. A failure here only costs the notification: it is
        /// discarded and never reaches the caller.
        /// </summary>
        public static async Task SaveSafelyAsync(DbContext db, CancellationToken ct)
        {
            try
            {
                await db.SaveChangesAsync(ct).ConfigureAwait(false);
            }
            catch (Exception)
            {
                foreach (var entry in db.ChangeTracker.Entries<IqaNotification>()
                             .Where(e => e.State == EntityState.Added).ToList())
                    entry.State = EntityState.Detached;
            }
        }

        // ------------------------------------------------------------------
        // Who
        // ------------------------------------------------------------------

        /// <summary>The name as printed on forms: prefix, first, middle, last, suffix.</summary>
        public static async Task<string> NameOfAsync(DbContext db, string? userId, CancellationToken ct)
        {
            if (string.IsNullOrWhiteSpace(userId)) return "Someone";

            var user = await db.Set<User>()
                .AsNoTracking()
                .FirstOrDefaultAsync(u => u.Id == userId, ct)
                .ConfigureAwait(false);
            if (user == null) return "Someone";

            var full = string.Join(" ", new[] { user.Prefix, user.FirstName, user.MiddleName, user.LastName, user.Suffix }
                .Where(p => !string.IsNullOrWhiteSpace(p)));
            if (!string.IsNullOrWhiteSpace(full)) return full;
            return string.IsNullOrWhiteSpace(user.UserName) ? "Someone" : user.UserName!;
        }

        public static Task<List<string>> UsersInRoleAsync(DbContext db, string roleName, CancellationToken ct) =>
            (from ur in db.Set<IdentityUserRole<string>>().AsNoTracking()
             join r in db.Set<IdentityRole>().AsNoTracking() on ur.RoleId equals r.Id
             where r.Name == roleName
             select ur.UserId)
            .Distinct()
            .ToListAsync(ct);

        public static Task<List<string>> OfficeHeadsAsync(DbContext db, IEnumerable<int> officeIds, CancellationToken ct)
        {
            var ids = officeIds.Distinct().ToList();
            return db.Set<UserOffices>()
                .AsNoTracking()
                .Where(uo => ids.Contains(uo.OfficeId) && uo.IsOfficeHead && uo.IsActive && !uo.IsDeleted)
                .Select(uo => uo.UserId)
                .Distinct()
                .ToListAsync(ct);
        }

        /// <summary>The heads of the offices named in a text such as "Department of Surgery, Pediatrics".</summary>
        public static async Task<List<string>> OfficeHeadsByNameAsync(DbContext db, string? officeNames, CancellationToken ct)
        {
            var names = (officeNames ?? string.Empty)
                .Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
                .Select(n => n.ToUpper())
                .Distinct()
                .ToList();
            if (names.Count == 0) return new List<string>();

            var officeIds = await db.Set<Office>()
                .AsNoTracking()
                .Where(o => !o.IsDeleted && names.Contains(o.Name.Trim().ToUpper()))
                .Select(o => o.Id)
                .ToListAsync(ct)
                .ConfigureAwait(false);

            return await OfficeHeadsAsync(db, officeIds, ct).ConfigureAwait(false);
        }

        /// <summary>
        /// The people who lead a team: whoever is marked as its leader and,
        /// like the reschedule approval, whoever holds the Auditor Team Leader
        /// role and belongs to it. With no team at all, everyone with the role.
        /// </summary>
        public static async Task<List<string>> TeamLeadersAsync(DbContext db, IEnumerable<int> teamIds, CancellationToken ct)
        {
            var teams = teamIds.Distinct().ToList();
            if (teams.Count == 0)
                return await UsersInRoleAsync(db, TeamLeaderRoleName, ct).ConfigureAwait(false);

            var roleHolders = (await UsersInRoleAsync(db, TeamLeaderRoleName, ct).ConfigureAwait(false))
                .ToHashSet(StringComparer.OrdinalIgnoreCase);

            var members = await db.Set<AuditorTeams>()
                .AsNoTracking()
                .Where(t => !t.IsDeleted && teams.Contains(t.TeamId) && t.Auditor != null)
                .Select(t => new { t.IsTeamLeader, t.Auditor!.UserId })
                .ToListAsync(ct)
                .ConfigureAwait(false);

            return members
                .Where(m => !string.IsNullOrWhiteSpace(m.UserId) && (m.IsTeamLeader || roleHolders.Contains(m.UserId!)))
                .Select(m => m.UserId!)
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();
        }

        public static async Task<List<string>> TeamMembersAsync(DbContext db, IEnumerable<int> teamIds, CancellationToken ct)
        {
            var teams = teamIds.Distinct().ToList();
            if (teams.Count == 0) return new List<string>();

            var users = await db.Set<AuditorTeams>()
                .AsNoTracking()
                .Where(t => !t.IsDeleted && teams.Contains(t.TeamId) && t.Auditor != null)
                .Select(t => t.Auditor!.UserId)
                .ToListAsync(ct)
                .ConfigureAwait(false);

            return users
                .Where(u => !string.IsNullOrWhiteSpace(u))
                .Select(u => u!)
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();
        }

        /// <summary>The teams of an audit schedule: its own team and the teams the plan entry lists.</summary>
        public static async Task<List<int>> ScheduleTeamIdsAsync(DbContext db, int scheduleId, CancellationToken ct)
        {
            var schedule = await db.Set<AuditSchedule>()
                .AsNoTracking()
                .Where(s => s.Id == scheduleId)
                .Select(s => new { s.TeamId, s.AuditPlanEntryId })
                .FirstOrDefaultAsync(ct)
                .ConfigureAwait(false);
            if (schedule == null) return new List<int>();

            var teams = await db.Set<IsoAuditor>()
                .AsNoTracking()
                .Where(a => !a.IsDeleted && a.AuditPlanEntryId == schedule.AuditPlanEntryId && a.TeamId != null)
                .Select(a => a.TeamId!.Value)
                .ToListAsync(ct)
                .ConfigureAwait(false);
            if (schedule.TeamId.HasValue) teams.Add(schedule.TeamId.Value);
            return teams.Distinct().ToList();
        }

        /// <summary>
        /// Who submitted an item: the user of its latest Submitted / Resubmitted
        /// approval-history row or, for items without history (the Audit
        /// Report), the actor of the notification raised at submission.
        /// </summary>
        public static async Task<string?> SubmitterAsync(DbContext db, string entityType, int entityId, CancellationToken ct)
        {
            var fromHistory = await db.Set<IQAApprovalHistory>()
                .AsNoTracking()
                .Where(h => h.AuditEntityType == entityType && h.AuditEntityId == entityId && h.UserId != null &&
                            (h.Action == "Submitted" || h.Action == "Resubmitted"))
                .OrderByDescending(h => h.ActionDate)
                .Select(h => h.UserId)
                .FirstOrDefaultAsync(ct)
                .ConfigureAwait(false);
            if (!string.IsNullOrWhiteSpace(fromHistory)) return fromHistory;

            long id = entityId;
            return await db.Set<IqaNotification>()
                .AsNoTracking()
                .Where(n => n.EntityType == entityType && n.EntityId == id && n.ActorUserId != null &&
                            (n.Type == Types.Submitted || n.Type == Types.Resubmitted))
                .OrderByDescending(n => n.CreatedAt)
                .Select(n => n.ActorUserId)
                .FirstOrDefaultAsync(ct)
                .ConfigureAwait(false);
        }
    }
}
