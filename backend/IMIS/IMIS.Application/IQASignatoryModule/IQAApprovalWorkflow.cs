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
            public const string Rejected = "REJECTED";
            public const string RevisionRequired = "REVISION_REQUIRED";
            public const string Resubmitted = "RESUBMITTED";
            public const string PendingConfirmation = "PENDING_CONFIRMATION";
            public const string Confirmed = "CONFIRMED";
        }

        public static class Decisions
        {
            public const string Pending = "Pending";
            public const string Approved = "Approved";
            public const string Disapproved = "Disapproved";
            public const string Rejected = "Rejected";
            public const string Noted = "Noted";
            public const string Confirmed = "Confirmed";
        }

        public static class Actions
        {
            public const string Submitted = "Submitted";
            public const string Resubmitted = "Resubmitted";
            public const string Approved = "Approved";
            public const string Rejected = "Rejected";
            public const string Noted = "Noted";
            public const string Confirmed = "Confirmed";
        }

        private static bool Is(string? value, string expected) =>
            string.Equals(value, expected, StringComparison.OrdinalIgnoreCase);

        /// <summary>
        /// Returns the candidate user id ONLY when a matching AspNetUsers row
        /// exists; otherwise null. IQAApprovalHistory.UserId and
        /// IQASignatory.SignatoryId are both FKs to AspNetUsers, so writing a
        /// placeholder ("system", "") or a stale id always dies with a
        /// DbUpdateException (FK 547). System-initiated transitions store a
        /// null actor instead — never a fake id.
        /// </summary>
        public static async Task<string?> ResolveActorUserIdAsync(
            DbContext db, string? userId, CancellationToken ct)
        {
            if (string.IsNullOrWhiteSpace(userId)) return null;
            var exists = await db.Set<User>()
                .AsNoTracking()
                .AnyAsync(u => u.Id == userId, ct)
                .ConfigureAwait(false);
            return exists ? userId : null;
        }

        public static string StateName(string stateCode, string? entityType = null) => stateCode switch
        {
            StateCodes.Pending => entityType == EntityTypes.AuditSchedule ? "Pending Confirmation" : "Pending Approval",
            StateCodes.PendingConfirmation => "Pending Confirmation",
            StateCodes.Approved => "Approved",
            StateCodes.Confirmed => "Confirmed",
            StateCodes.Disapproved => "Rejected",
            StateCodes.Rejected => "Rejected",
            StateCodes.RevisionRequired => "Revision Required",
            StateCodes.Resubmitted => "Resubmitted",
            _ => entityType == EntityTypes.AuditSchedule ? "Pending Confirmation" : "Draft"
        };

        public static int GetWorkflowOrder(IQASignatoryTemplate? template)
        {
            if (template == null) return 99;
            var label = (template.SignatoryLabel ?? "").ToUpperInvariant();
            var pos = (template.Position ?? "").ToUpperInvariant();

            if (label.Contains("PREPAR") || pos.Contains("PREPAR") || label.Contains("LEAD AUDITOR") || pos.Contains("LEAD AUDITOR"))
                return 1;
            if (label.Contains("NOTE") || pos.Contains("NOTE") || label.Contains("RECOMMEND") || pos.Contains("REVIEW") || label.Contains("ENDORSE"))
                return 2;
            if (label.Contains("APPROV") || pos.Contains("APPROV") || label.Contains("QMR") || pos.Contains("CHIEF"))
                return 3;

            return template.OrderLevel > 0 ? template.OrderLevel : 99;
        }

        /// <summary>Live (not deleted) rows in workflow hierarchy order.</summary>
        public static List<IQASignatory> Ordered(IEnumerable<IQASignatory>? signatories) =>
            (signatories ?? Enumerable.Empty<IQASignatory>())
                .Where(s => !s.IsDeleted)
                .OrderBy(s => GetWorkflowOrder(s.IQASignatoryTemplate))
                .ThenBy(s => s.IQASignatoryTemplate?.OrderLevel ?? int.MaxValue)
                .ThenBy(s => s.Id)
                .ToList();

        public static string DeriveStateCode(
            IEnumerable<IQASignatory>? signatories,
            string? entityType = null,
            bool hasScheduleNeedingRevision = false)
        {
            if (hasScheduleNeedingRevision)
                return StateCodes.RevisionRequired;

            var ordered = Ordered(signatories);
            var statuses = ordered.Select(s => s.ApprovalStatus).ToList();

            if (statuses.Count == 0)
            {
                // CRITICAL BUSINESS RULE: Audit Schedule has NO Draft status!
                // It is always pending confirmation immediately upon creation.
                return entityType == EntityTypes.AuditSchedule ? StateCodes.PendingConfirmation : StateCodes.Draft;
            }

            if (statuses.Any(s => Is(s, Decisions.Rejected) || Is(s, Decisions.Disapproved)))
                return StateCodes.RevisionRequired;

            bool allSigned = statuses.All(s =>
                Is(s, Decisions.Approved) || Is(s, Decisions.Noted) || Is(s, Decisions.Confirmed));

            if (allSigned)
            {
                return entityType == EntityTypes.AuditSchedule ? StateCodes.Confirmed : StateCodes.Approved;
            }

            return entityType == EntityTypes.AuditSchedule ? StateCodes.PendingConfirmation : StateCodes.Pending;
        }

        public static async Task<string> GetStateCodeAsync(
            DbContext db, string entityType, int entityId, CancellationToken ct)
        {
            var statuses = await db.Set<IQASignatory>()
                .AsNoTracking()
                .Where(s => s.AuditEntityType == entityType && s.AuditEntityId == entityId && !s.IsDeleted)
                .Select(s => s.ApprovalStatus)
                .ToListAsync(ct);

            bool scheduleNeedsRevision = false;
            if (entityType == EntityTypes.AuditPlan)
            {
                scheduleNeedsRevision = await db.Set<AuditSchedule>()
                    .Where(s => s.AuditPlanId == entityId && !s.IsDeleted)
                    .SelectMany(s => s.IQASignatories.Where(sig => !sig.IsDeleted))
                    .AnyAsync(sig => sig.ApprovalStatus == Decisions.Rejected || sig.ApprovalStatus == Decisions.Disapproved, ct);
            }

            return DeriveStateCode(
                statuses.Select(st => new IQASignatory { Id = 0, AuditEntityType = entityType, AuditEntityId = entityId, SignatoryId = "", ApprovalStatus = st }),
                entityType,
                scheduleNeedsRevision);
        }

        /// <summary>
        /// Draft / Rejected / Revision Required -> Pending Approval (or Pending Confirmation).
        /// Soft-deletes any previous active signatory chain and creates a fresh Pending row per template.
        /// Records persistent entry in IQAApprovalHistory (survives resubmissions).
        /// </summary>
        public static async Task<(bool Success, string? Error)> SubmitAsync(
            DbContext db,
            string entityType,
            int entityId,
            string displayName,
            string? userId,
            string? comments,
            CancellationToken ct)
        {
            var live = await db.Set<IQASignatory>()
                .Where(s => s.AuditEntityType == entityType && s.AuditEntityId == entityId && !s.IsDeleted)
                .ToListAsync(ct);

            var state = DeriveStateCode(live, entityType);
            if (entityType != EntityTypes.AuditSchedule &&
                state != StateCodes.Draft &&
                state != StateCodes.Disapproved &&
                state != StateCodes.Rejected &&
                state != StateCodes.RevisionRequired)
            {
                return (false, $"Cannot submit {displayName} from status '{StateName(state, entityType)}'.");
            }

            var templates = await db.Set<IQASignatoryTemplate>()
                .AsNoTracking()
                .Where(t => t.AuditEntityType == entityType && t.IsActive && !t.IsDeleted)
                .OrderBy(t => t.OrderLevel).ThenBy(t => t.Id)
                .ToListAsync(ct);

            if (templates.Count == 0 && entityType != EntityTypes.AuditSchedule)
                return (false, $"No active approval signatory template is configured for {displayName}.");

            // For AuditSchedule, find the Department Head of the scheduled office
            string? deptHeadUserId = null;
            string? scheduledOfficeName = null;
            if (entityType == EntityTypes.AuditSchedule)
            {
                var schedule = await db.Set<AuditSchedule>()
                    .Include(s => s.AuditableOffices!)
                        .ThenInclude(ao => ao.Office)
                    .FirstOrDefaultAsync(s => s.Id == entityId, ct);

                var office = schedule?.AuditableOffices?.FirstOrDefault()?.Office;
                if (office != null)
                {
                    scheduledOfficeName = office.Name;
                    var head = await db.Set<UserOffices>()
                        .Where(uo => uo.OfficeId == office.Id && uo.IsOfficeHead && uo.IsActive && !uo.IsDeleted)
                        .Select(uo => uo.UserId)
                        .FirstOrDefaultAsync(ct);
                    if (!string.IsNullOrWhiteSpace(head))
                    {
                        deptHeadUserId = head;
                    }
                }
            }

            // Check if any template lacks a signatory
            foreach (var t in templates)
            {
                if (entityType == EntityTypes.AuditSchedule)
                    continue; // Audit schedule uses dynamic department head or confirming user

                bool isDeptHeadSlot = t.SignatoryLabel.Contains("Department Head", StringComparison.OrdinalIgnoreCase);
                if (isDeptHeadSlot && !string.IsNullOrWhiteSpace(deptHeadUserId))
                {
                    continue; // Will use resolved department head
                }
                if (string.IsNullOrWhiteSpace(t.DefaultSignatoryId))
                {
                    return (false, $"No default signatory is assigned for: {t.SignatoryLabel}.");
                }
            }

            var hadRejection = await db.Set<IQAApprovalHistory>()
                .AnyAsync(h => h.AuditEntityType == entityType && h.AuditEntityId == entityId &&
                    (h.Action == Actions.Rejected || h.Status == StateName(StateCodes.RevisionRequired, entityType)), ct);

            // Retire previous live signatory chain (their history remains preserved in IQAApprovalHistory)
            foreach (var old in live)
                old.IsDeleted = true;

            var orderedTemplates = templates
                .OrderBy(t => GetWorkflowOrder(t))
                .ThenBy(t => t.OrderLevel)
                .ThenBy(t => t.Id)
                .ToList();

            // Actor must be a real AspNetUsers row — placeholders ("system",
            // "") violate the UserId/SignatoryId FKs (DbUpdateException 547).
            var actorUserId = await ResolveActorUserIdAsync(db, userId, ct)
                .ConfigureAwait(false);

            if (entityType == EntityTypes.AuditSchedule && orderedTemplates.Count == 0)
            {
                var schedSignatoryId = deptHeadUserId ?? actorUserId;
                // No resolvable signatory: skip the slot row entirely rather
                // than inserting a blank FK. Zero live rows still derives to
                // Pending Confirmation, and DecideAsync bootstraps the chain
                // on the first real decision.
                if (!string.IsNullOrWhiteSpace(schedSignatoryId))
                {
                    var defaultSchedRow = new IQASignatory
                    {
                        Id = 0,
                        AuditEntityType = entityType,
                        AuditEntityId = entityId,
                        AuditScheduleId = entityId,
                        SignatoryId = schedSignatoryId,
                        ApprovalStatus = Decisions.Pending
                    };
                    db.Set<IQASignatory>().Add(defaultSchedRow);
                }
            }
            else
            {
                foreach (var template in orderedTemplates)
                {
                    string targetSignatoryId = template.DefaultSignatoryId ?? "";
                    bool isDeptHeadSlot = template.SignatoryLabel.Contains("Department Head", StringComparison.OrdinalIgnoreCase);
                    if (isDeptHeadSlot && !string.IsNullOrWhiteSpace(deptHeadUserId))
                    {
                        targetSignatoryId = deptHeadUserId;
                    }
                    else if (entityType == EntityTypes.AuditSchedule && string.IsNullOrWhiteSpace(targetSignatoryId))
                    {
                        targetSignatoryId = deptHeadUserId ?? actorUserId ?? "";
                    }

                    int stage = GetWorkflowOrder(template);
                    bool isPreparer = stage == 1 && entityType != EntityTypes.AuditSchedule;

                    var finalSignatoryId = isPreparer && actorUserId != null ? actorUserId : targetSignatoryId;
                    // Same FK guard: a slot with no resolvable user is left
                    // out instead of crashing the whole save.
                    if (string.IsNullOrWhiteSpace(finalSignatoryId)) continue;

                    var row = new IQASignatory
                    {
                        Id = 0,
                        AuditEntityType = entityType,
                        AuditEntityId = entityId,
                        IQASignatoryTemplateId = template.Id,
                        SignatoryId = finalSignatoryId,
                        ApprovalStatus = isPreparer ? Decisions.Approved : Decisions.Pending,
                        DateSigned = isPreparer ? DateTime.UtcNow : null,
                        Remarks = isPreparer ? "Prepared and submitted" : null
                    };

                    switch (entityType)
                    {
                        case EntityTypes.AuditProgramme: row.AuditProgrammeId = entityId; break;
                        case EntityTypes.AuditPlan: row.AuditPlanId = entityId; break;
                        case EntityTypes.AuditSchedule: row.AuditScheduleId = entityId; break;
                    }

                    db.Set<IQASignatory>().Add(row);
                }
            }

            string actionName = hadRejection ? Actions.Resubmitted : Actions.Submitted;
            string resultingStatus = entityType == EntityTypes.AuditSchedule
                ? "Pending Confirmation"
                : "Pending Approval";

            var historyRecord = new IQAApprovalHistory
            {
                Id = 0,
                AuditEntityType = entityType,
                AuditEntityId = entityId,
                AuditProgrammeId = entityType == EntityTypes.AuditProgramme ? entityId : null,
                AuditPlanId = entityType == EntityTypes.AuditPlan ? entityId : null,
                AuditScheduleId = entityType == EntityTypes.AuditSchedule ? entityId : null,
                Action = actionName,
                Status = resultingStatus,
                // Null when no real user performed this (system transition).
                // Never "system"/"" — those ids don't exist in AspNetUsers
                // and violate the FK (DbUpdateException 547).
                UserId = actorUserId,
                ActionDate = DateTime.UtcNow,
                Comments = comments,
                OfficeName = scheduledOfficeName,
                RoleOrPosition = "Preparer"
            };

            db.Set<IQAApprovalHistory>().Add(historyRecord);

            return (true, null);
        }

        public static Task<(bool Success, string? Error)> SubmitAsync(
            DbContext db, string entityType, int entityId, string displayName, CancellationToken ct) =>
            SubmitAsync(db, entityType, entityId, displayName, null, null, ct);

        /// <summary>
        /// Handles Approve, Reject, Noted, Confirm decisions.
        /// When rejected: comments/reason is REQUIRED.
        /// Records persistent entry in IQAApprovalHistory.
        /// </summary>
        public static async Task<(bool Success, string? Error)> DecideAsync(
            DbContext db,
            string entityType,
            int entityId,
            string displayName,
            string approverId,
            string action,
            string? comments,
            string? officeName,
            CancellationToken ct)
        {
            var live = Ordered(await db.Set<IQASignatory>()
                .Include(s => s.IQASignatoryTemplate)
                .Where(s => s.AuditEntityType == entityType && s.AuditEntityId == entityId && !s.IsDeleted)
                .ToListAsync(ct));

            // CRITICAL: Audit Schedule has NO Draft status.
            // If live has no signatory rows, initialize the pending confirmation signatory immediately!
            if (entityType == EntityTypes.AuditSchedule && live.Count == 0)
            {
                var template = await db.Set<IQASignatoryTemplate>()
                    .AsNoTracking()
                    .Where(t => t.AuditEntityType == EntityTypes.AuditSchedule && t.IsActive && !t.IsDeleted &&
                                t.SignatoryLabel.Contains("Department Head"))
                    .FirstOrDefaultAsync(ct);

                var schedSignatory = new IQASignatory
                {
                    Id = 0,
                    AuditEntityType = EntityTypes.AuditSchedule,
                    AuditEntityId = entityId,
                    AuditScheduleId = entityId,
                    IQASignatoryTemplateId = template?.Id,
                    SignatoryId = approverId,
                    ApprovalStatus = Decisions.Pending
                };

                db.Set<IQASignatory>().Add(schedSignatory);
                live = new List<IQASignatory> { schedSignatory };
            }

            var state = DeriveStateCode(live, entityType);
            if (state != StateCodes.Pending && state != StateCodes.PendingConfirmation)
                return (false, $"Cannot decide on {displayName} in status '{StateName(state, entityType)}'.");

            // The approver id lands in IQASignatory.SignatoryId and
            // IQAApprovalHistory.UserId — both FKs to AspNetUsers. Reject an
            // unknown id here with a clean failure instead of a 500 FK crash,
            // and use the verified id downstream.
            var verifiedApproverId = await ResolveActorUserIdAsync(db, approverId, ct)
                .ConfigureAwait(false);
            if (verifiedApproverId == null)
                return (false, "Approver account not found.");
            approverId = verifiedApproverId;

            // Check if user is an Administrator (Admin has master override across all workflow approvals)
            bool isAdmin = false;
            if (!string.IsNullOrWhiteSpace(approverId))
            {
                var adminRoleId = "56996e97-9e8a-4d22-a693-c865144e9b96";
                isAdmin = await db.Set<Microsoft.AspNetCore.Identity.IdentityUserRole<string>>()
                    .AnyAsync(ur => ur.UserId == approverId && ur.RoleId == adminRoleId, ct);
            }

            // Find matching pending slot for this caller:
            // First check if approverId directly matches a pending slot (e.g. Dr. Arumpac or Dr. Maliga)
            var targetSlot = live.FirstOrDefault(s =>
                string.Equals(s.SignatoryId, approverId, StringComparison.OrdinalIgnoreCase) &&
                !Is(s.ApprovalStatus, Decisions.Approved) &&
                !Is(s.ApprovalStatus, Decisions.Noted) &&
                !Is(s.ApprovalStatus, Decisions.Confirmed));

            // Department Head dynamic association for AuditSchedule
            if (targetSlot == null && entityType == EntityTypes.AuditSchedule)
            {
                var deptSlot = live.FirstOrDefault(s =>
                    !Is(s.ApprovalStatus, Decisions.Approved) &&
                    !Is(s.ApprovalStatus, Decisions.Confirmed));

                if (deptSlot != null)
                {
                    deptSlot.SignatoryId = approverId;
                    targetSlot = deptSlot;
                }
            }

            // If Admin or no exact slot, pick the next pending slot
            if (targetSlot == null && isAdmin)
            {
                if (Is(action, Actions.Approved) || Is(action, "Approve"))
                {
                    targetSlot = live.LastOrDefault(s =>
                        !Is(s.ApprovalStatus, Decisions.Approved) &&
                        !Is(s.ApprovalStatus, Decisions.Noted) &&
                        !Is(s.ApprovalStatus, Decisions.Confirmed));
                }
                else
                {
                    targetSlot = live.FirstOrDefault(s =>
                        !Is(s.ApprovalStatus, Decisions.Approved) &&
                        !Is(s.ApprovalStatus, Decisions.Noted) &&
                        !Is(s.ApprovalStatus, Decisions.Confirmed));
                }

                if (targetSlot != null)
                {
                    targetSlot.SignatoryId = approverId;
                }
            }

            if (targetSlot == null)
            {
                return (false, $"You are not an authorized pending signatory for {displayName}.");
            }

            bool isRejection = Is(action, Actions.Rejected) || Is(action, "Disapprove") || Is(action, "Reject");

            if (isRejection)
            {
                if (string.IsNullOrWhiteSpace(comments))
                {
                    return (false, "Please provide a comment or reason for rejection.");
                }

                targetSlot.ApprovalStatus = Decisions.Rejected;
                targetSlot.DateSigned = DateTime.UtcNow;
                targetSlot.Remarks = comments;

                var rejectionRecord = new IQAApprovalHistory
                {
                    Id = 0,
                    AuditEntityType = entityType,
                    AuditEntityId = entityId,
                    AuditProgrammeId = entityType == EntityTypes.AuditProgramme ? entityId : null,
                    AuditPlanId = entityType == EntityTypes.AuditPlan ? entityId : null,
                    AuditScheduleId = entityType == EntityTypes.AuditSchedule ? entityId : null,
                    Action = Actions.Rejected,
                    Status = "Revision Required",
                    UserId = approverId,
                    ActionDate = DateTime.UtcNow,
                    Comments = comments,
                    OfficeName = officeName,
                    RoleOrPosition = targetSlot.IQASignatoryTemplate?.SignatoryLabel ?? (isAdmin ? "Administrator" : "Approver")
                };
                db.Set<IQAApprovalHistory>().Add(rejectionRecord);

                return (true, null);
            }

            string normalizedAction = Actions.Approved;
            string decisionStatus = Decisions.Approved;

            if (Is(action, Actions.Noted) || Is(action, "Note"))
            {
                normalizedAction = Actions.Noted;
                decisionStatus = Decisions.Noted;
            }
            else if (Is(action, Actions.Confirmed) || Is(action, "Confirm"))
            {
                normalizedAction = Actions.Confirmed;
                decisionStatus = Decisions.Confirmed;
            }

            targetSlot.ApprovalStatus = decisionStatus;
            targetSlot.DateSigned = DateTime.UtcNow;
            targetSlot.Remarks = comments;

            // An Audit Schedule is confirmed by the Department Head in ONE act.
            // Its seeded chain (Lead Auditor -> Department Head -> QMR) is a
            // formality, so completing any single slot must finalise the whole
            // schedule. Without this, a single "Confirm" leaves the other slots
            // Pending and the schedule is stuck on "Pending Confirmation".
            if (entityType == EntityTypes.AuditSchedule &&
                (normalizedAction == Actions.Approved || normalizedAction == Actions.Confirmed))
            {
                var otherUnsigned = live.Where(s =>
                    s.Id != targetSlot.Id &&
                    !Is(s.ApprovalStatus, Decisions.Approved) &&
                    !Is(s.ApprovalStatus, Decisions.Noted) &&
                    !Is(s.ApprovalStatus, Decisions.Confirmed)).ToList();

                foreach (var other in otherUnsigned)
                {
                    other.ApprovalStatus = Decisions.Noted;
                    other.DateSigned = DateTime.UtcNow;
                    other.Remarks = "Noted upon schedule confirmation";
                }
            }

            // If the final approver approves (e.g. Dr. Maliga), mark any preceding uncompleted review/noted slots as Noted
            int targetStage = GetWorkflowOrder(targetSlot.IQASignatoryTemplate);
            if (targetStage >= 3 && (normalizedAction == Actions.Approved || normalizedAction == Actions.Confirmed))
            {
                var precedingUnsigned = live.Where(s =>
                    GetWorkflowOrder(s.IQASignatoryTemplate) < targetStage &&
                    !Is(s.ApprovalStatus, Decisions.Approved) &&
                    !Is(s.ApprovalStatus, Decisions.Noted) &&
                    !Is(s.ApprovalStatus, Decisions.Confirmed)).ToList();

                foreach (var prec in precedingUnsigned)
                {
                    prec.ApprovalStatus = Decisions.Noted;
                    prec.DateSigned = DateTime.UtcNow;
                    prec.Remarks = "Noted upon final approval";
                }
            }

            var remaining = live.Where(s =>
                s.Id != targetSlot.Id &&
                !Is(s.ApprovalStatus, Decisions.Approved) &&
                !Is(s.ApprovalStatus, Decisions.Noted) &&
                !Is(s.ApprovalStatus, Decisions.Confirmed)).ToList();

            bool isFullyApproved = remaining.Count == 0;
            string resultingStatus = isFullyApproved
                ? (entityType == EntityTypes.AuditSchedule ? "Confirmed" : "Approved")
                : (entityType == EntityTypes.AuditSchedule ? "Pending Confirmation" : "Pending Approval");

            var historyRecord = new IQAApprovalHistory
            {
                Id = 0,
                AuditEntityType = entityType,
                AuditEntityId = entityId,
                AuditProgrammeId = entityType == EntityTypes.AuditProgramme ? entityId : null,
                AuditPlanId = entityType == EntityTypes.AuditPlan ? entityId : null,
                AuditScheduleId = entityType == EntityTypes.AuditSchedule ? entityId : null,
                Action = normalizedAction,
                Status = resultingStatus,
                UserId = approverId,
                ActionDate = DateTime.UtcNow,
                Comments = comments,
                OfficeName = officeName,
                RoleOrPosition = targetSlot.IQASignatoryTemplate?.SignatoryLabel ?? (isAdmin ? "Administrator" : "Approver")
            };
            db.Set<IQAApprovalHistory>().Add(historyRecord);

            return (true, null);
        }

        public static Task<(bool Success, string? Error)> DecideAsync(
            DbContext db,
            string entityType,
            int entityId,
            string displayName,
            string approverId,
            bool approve,
            string? remarks,
            CancellationToken ct) =>
            DecideAsync(db, entityType, entityId, displayName, approverId, approve ? Actions.Approved : Actions.Rejected, remarks, null, ct);
    }
}