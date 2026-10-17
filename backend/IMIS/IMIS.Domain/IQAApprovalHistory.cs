using Base.Primitives;
using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace IMIS.Domain
{
    /// <summary>
    /// Permanent, persistent log of every approval/rejection/confirmation/submission
    /// action taken on an audit entity (AuditProgramme, AuditPlan, or AuditSchedule).
    /// This history is never soft-deleted and survives across resubmissions.
    /// </summary>
    public class IQAApprovalHistory : Entity<long>
    {
        /// <summary>
        /// Audit entity type: "AuditProgramme", "AuditPlan", or "AuditSchedule"
        /// </summary>
        public required string AuditEntityType { get; set; }

        /// <summary>
        /// ID of the audit entity (AuditProgrammeId, AuditPlanId, or AuditScheduleId)
        /// </summary>
        public required int AuditEntityId { get; set; }

        /// <summary>
        /// Navigation to associated AuditProgramme (if AuditEntityType == "AuditProgramme")
        /// </summary>
        public int? AuditProgrammeId { get; set; }
        [ForeignKey(nameof(AuditProgrammeId))]
        public virtual AuditProgramme? AuditProgramme { get; set; }

        /// <summary>
        /// Navigation to associated AuditPlan (if AuditEntityType == "AuditPlan")
        /// </summary>
        public int? AuditPlanId { get; set; }
        [ForeignKey(nameof(AuditPlanId))]
        public virtual AuditPlan? AuditPlan { get; set; }

        /// <summary>
        /// Navigation to associated AuditSchedule (if AuditEntityType == "AuditSchedule")
        /// </summary>
        public int? AuditScheduleId { get; set; }
        [ForeignKey(nameof(AuditScheduleId))]
        public virtual AuditSchedule? AuditSchedule { get; set; }

        /// <summary>
        /// Action taken: "Submitted", "Resubmitted", "Approved", "Rejected", "Noted", "Confirmed"
        /// </summary>
        public required string Action { get; set; }

        /// <summary>
        /// Resulting workflow status: "Draft", "Pending Approval", "Approved", "Rejected", 
        /// "Revision Required", "Pending Confirmation", "Confirmed", "Resubmitted"
        /// </summary>
        public required string Status { get; set; }

        /// <summary>
        /// User who performed the action. NULLABLE by design: system-initiated
        /// transitions (e.g. auto-created audit schedules) have no real user,
        /// and the FK to AspNetUsers rejects placeholder ids like "system".
        /// </summary>
        public string? UserId { get; set; }
        [ForeignKey(nameof(UserId))]
        public virtual User? User { get; set; }

        /// <summary>
        /// Exact timestamp of the action
        /// </summary>
        public DateTime ActionDate { get; set; } = DateTime.UtcNow;

        /// <summary>
        /// Comments or reason (REQUIRED when action is "Rejected")
        /// </summary>
        public string? Comments { get; set; }

        /// <summary>
        /// Department or office name (e.g. for Department Head confirmation of schedules)
        /// </summary>
        public string? OfficeName { get; set; }

        /// <summary>
        /// Role or position label at the time of action (e.g., "Preparer", "Lead Auditor", "Department Head", "QMR")
        /// </summary>
        public string? RoleOrPosition { get; set; }
    }
}
