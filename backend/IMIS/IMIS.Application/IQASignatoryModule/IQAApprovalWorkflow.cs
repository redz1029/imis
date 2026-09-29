using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.IQASignatoryModule
{
    /// <summary>
    /// Shared approval logic for every audit entity that uses IQASignatory /
    /// IQASignatoryTemplate. Methods only add or modify tracked entities and
    /// never call SaveChanges, so the caller commits everything atomically.
    /// </summary>
    public static class IQAApprovalWorkflow
    {
        public static class EntityTypes
        {
            public const string AuditProgramme = "AuditProgramme";
            public const string AuditPlan = "AuditPlan";
            public const string AuditSchedule = "AuditSchedule";
        }

        public static class StateCodes
        {
            public const string Draft = "DRAFT";
            public const string Pending = "PENDING";
            public const string Approved = "APPROVED";
            public const string Disapproved = "DISAPPROVED";
        }

        public static class Decisions
        {
            public const string Pending = "Pending";
            public const string Approved = "Approved";
            public const string Disapproved = "Disapproved";
        }

        private static bool Is(string? value, string expected) =>
            string.Equals(value, expected, StringComparison.OrdinalIgnoreCase);

        public static string StateName(string stateCode) => stateCode switch
        {
            StateCodes.Pending => "Pending",
            StateCodes.Approved => "Approved",
            StateCodes.Disapproved => "Disapproved",
            _ => "Draft"
        };

        /// <summary>Live (not deleted) rows in approval order.</summary>
        public static List<IQASignatory> Ordered(IEnumerable<IQASignatory>? signatories) =>
            (signatories ?? Enumerable.Empty<IQASignatory>())
                .Where(s => !s.IsDeleted)
                .OrderBy(s => s.IQASignatoryTemplate?.OrderLevel ?? int.MaxValue)
                .ThenBy(s => s.Id)
                .ToList();

        public static string DeriveStateCode(IEnumerable<IQASignatory>? signatories) =>
            DeriveFromStatuses(Ordered(signatories).Select(s => s.ApprovalStatus).ToList());

        private static string DeriveFromStatuses(IReadOnlyCollection<string?> statuses)
        {
            if (statuses.Count == 0) return StateCodes.Draft;
            if (statuses.Any(s => Is(s, Decisions.Disapproved))) return StateCodes.Disapproved;
            if (statuses.Any(s => !Is(s, Decisions.Approved))) return StateCodes.Pending;
            return StateCodes.Approved;
        }

        public static async Task<string> GetStateCodeAsync(
            DbContext db, string entityType, int entityId, CancellationToken ct)
        {
            var statuses = await db.Set<IQASignatory>()
                .AsNoTracking()
                .Where(s => s.AuditEntityType == entityType && s.AuditEntityId == entityId && !s.IsDeleted)
                .Select(s => s.ApprovalStatus)
                .ToListAsync(ct);

            return DeriveFromStatuses(statuses);
        }

        /// <summary>
        /// Draft or Disapproved -> Pending. Retires any previous chain (soft delete,
        /// rows stay in the DB) and creates a fresh Pending row per template.
        /// </summary>
        public static async Task<(bool Success, string? Error)> SubmitAsync(
            DbContext db, string entityType, int entityId, string displayName, CancellationToken ct)
        {
            var live = await db.Set<IQASignatory>()
                .Where(s => s.AuditEntityType == entityType && s.AuditEntityId == entityId && !s.IsDeleted)
                .ToListAsync(ct);

            var state = DeriveStateCode(live);
            if (state != StateCodes.Draft && state != StateCodes.Disapproved)
                return (false, $"Cannot submit {displayName} from status '{StateName(state)}'.");

            var templates = await db.Set<IQASignatoryTemplate>()
                .AsNoTracking()
                .Where(t => t.AuditEntityType == entityType && t.IsActive && !t.IsDeleted)
                .OrderBy(t => t.OrderLevel).ThenBy(t => t.Id)
                .ToListAsync(ct);

            if (templates.Count == 0)
                return (false, $"No active approval signatory template is configured for {displayName}.");

            if (templates.Select(t => t.OfficeId).Distinct().Count() > 1)
                return (false, $"Approval signatory templates for {displayName} are configured under more than one office. Keep a single active chain.");

            // Never skip a level silently: a chain with a missing level would
            // otherwise reach "Approved" without that person ever signing.
            var missing = templates
                .Where(t => string.IsNullOrWhiteSpace(t.DefaultSignatoryId))
                .Select(t => t.SignatoryLabel)
                .ToList();
            if (missing.Count > 0)
                return (false, $"No default signatory is assigned for: {string.Join(", ", missing)}.");

            foreach (var old in live)
                old.IsDeleted = true;

            foreach (var template in templates)
            {
                var row = new IQASignatory
                {
                    Id = 0,
                    AuditEntityType = entityType,
                    AuditEntityId = entityId,
                    IQASignatoryTemplateId = template.Id,
                    SignatoryId = template.DefaultSignatoryId!,
                    ApprovalStatus = Decisions.Pending
                };

                switch (entityType)
                {
                    case EntityTypes.AuditProgramme: row.AuditProgrammeId = entityId; break;
                    case EntityTypes.AuditPlan: row.AuditPlanId = entityId; break;
                    case EntityTypes.AuditSchedule: row.AuditScheduleId = entityId; break;
                }

                db.Set<IQASignatory>().Add(row);
            }

            return (true, null);
        }

        /// <summary>
        /// Pending -> Approved/Disapproved. Signs the FIRST unsigned row, and only if it belongs
        /// to approverId. A disapproval stops the chain; later rows are left untouched.
        /// </summary>
        public static async Task<(bool Success, string? Error)> DecideAsync(
            DbContext db, string entityType, int entityId, string displayName,
            string approverId, bool approve, string? remarks, CancellationToken ct)
        {
            var live = Ordered(await db.Set<IQASignatory>()
                .Include(s => s.IQASignatoryTemplate)
                .Where(s => s.AuditEntityType == entityType && s.AuditEntityId == entityId && !s.IsDeleted)
                .ToListAsync(ct));

            var state = DeriveStateCode(live);
            if (state != StateCodes.Pending)
                return (false, $"Cannot decide on {displayName} in status '{StateName(state)}'.");

            var next = live.FirstOrDefault(s => !Is(s.ApprovalStatus, Decisions.Approved));
            if (next == null)
                return (false, "No pending signatory found.");

            if (!string.Equals(next.SignatoryId, approverId, StringComparison.OrdinalIgnoreCase))
            {
                var inChain = live.Any(s =>
                    !Is(s.ApprovalStatus, Decisions.Approved) &&
                    string.Equals(s.SignatoryId, approverId, StringComparison.OrdinalIgnoreCase));
                var waitingOn = next.IQASignatoryTemplate?.SignatoryLabel ?? "the previous signatory";

                return (false, inChain
                    ? $"It is not your turn to sign yet. Waiting for {waitingOn}."
                    : $"You are not a pending signatory for {displayName}.");
            }

            next.ApprovalStatus = approve ? Decisions.Approved : Decisions.Disapproved;
            next.DateSigned = DateTime.UtcNow;
            next.Remarks = remarks;

            return (true, null);
        }
    }
}