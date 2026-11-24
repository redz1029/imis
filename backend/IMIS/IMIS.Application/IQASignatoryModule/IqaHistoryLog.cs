using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.IQASignatoryModule
{
    /// <summary>
    /// The permanent "who did what, when" trail of the IQA documents that have
    /// no approval workflow of their own writing it: the Audit Report and the
    /// Audit Checklist. The rows go into <see cref="IQAApprovalHistory"/>, keyed
    /// by (AuditEntityType, AuditEntityId); the Audit Checklist is keyed by its
    /// Audit Schedule id. Like <see cref="IQAApprovalWorkflow"/> it only adds
    /// tracked rows and never calls SaveChanges, so the caller commits them.
    /// </summary>
    public static class IqaHistoryLog
    {
        public static class EntityTypes
        {
            public const string AuditReport = "AuditReport";
            public const string AuditChecklist = "AuditChecklist";
        }

        public static class Actions
        {
            // Audit Report (its approval chain)
            public const string Submitted = "Submitted";
            public const string Resubmitted = "Resubmitted";
            public const string Approved = "Approved";
            public const string Noted = "Noted";
            public const string Acknowledged = "Acknowledged";
            public const string Rejected = "Rejected";

            // Audit Checklist
            public const string ClausesAssigned = "Clauses Assigned";
            public const string QuestionAdded = "Question Added";
            public const string QuestionRemoved = "Question Removed";
            public const string Answered = "Answered";
        }

        /// <summary>The entity types whose trail can be read through the history endpoint.</summary>
        public static bool IsReadable(string? entityType) =>
            entityType is IQAApprovalWorkflow.EntityTypes.AuditProgramme
                       or IQAApprovalWorkflow.EntityTypes.AuditPlan
                       or IQAApprovalWorkflow.EntityTypes.AuditSchedule
                       or EntityTypes.AuditReport
                       or EntityTypes.AuditChecklist;

        /// <summary>
        /// Saves the rows added by <see cref="AddAsync"/> once the action itself is
        /// already saved. A failure only costs the history line: it is discarded
        /// and never reaches the caller.
        /// </summary>
        public static async Task SaveSafelyAsync(DbContext db, CancellationToken ct)
        {
            try
            {
                await db.SaveChangesAsync(ct).ConfigureAwait(false);
            }
            catch (Exception)
            {
                foreach (var entry in db.ChangeTracker.Entries<IQAApprovalHistory>()
                             .Where(e => e.State == EntityState.Added).ToList())
                    entry.State = EntityState.Detached;
            }
        }

        /// <summary>
        /// Adds one history row. The actor must be a real user; anything else is
        /// stored as "no user" instead of breaking the foreign key.
        /// </summary>
        public static async Task AddAsync(
            DbContext db,
            string entityType,
            int entityId,
            string action,
            string status,
            string? userId,
            string? comments,
            string? officeName,
            string? roleOrPosition,
            CancellationToken ct)
        {
            var actor = await IQAApprovalWorkflow.ResolveActorUserIdAsync(db, userId, ct).ConfigureAwait(false);

            db.Set<IQAApprovalHistory>().Add(new IQAApprovalHistory
            {
                Id = 0,
                AuditEntityType = entityType,
                AuditEntityId = entityId,
                Action = action,
                Status = status,
                UserId = actor,
                ActionDate = DateTime.UtcNow,
                Comments = string.IsNullOrWhiteSpace(comments) ? null : comments.Trim(),
                OfficeName = string.IsNullOrWhiteSpace(officeName) ? null : officeName.Trim(),
                RoleOrPosition = string.IsNullOrWhiteSpace(roleOrPosition) ? null : roleOrPosition.Trim()
            });
        }
    }
}
