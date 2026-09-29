using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    /// <summary>
    /// Records an actual signatory approval for audit entities (Programme, Plan, Schedule).
    /// One IQASignatory record per approval at each level in the approval chain.
    /// Similar to PgsSignatory but handles three audit entity types.
    /// </summary>
    public class IQASignatory : Entity<long>
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
        /// Reference to approval template (defines order, role, status)
        /// </summary>
        public int? IQASignatoryTemplateId { get; set; }
        [ForeignKey(nameof(IQASignatoryTemplateId))]
        public virtual IQASignatoryTemplate? IQASignatoryTemplate { get; set; }

        /// <summary>
        /// ID of the signatory user
        /// </summary>
        public required string SignatoryId { get; set; }
        [ForeignKey(nameof(SignatoryId))]
        public virtual User? Signatory { get; set; }

        /// <summary>
        /// Timestamp when signed
        /// </summary>
        public DateTime? DateSigned { get; set; }

        /// <summary>
        /// Optional remarks/comments from the signatory
        /// </summary>
        public string? Remarks { get; set; }

        /// <summary>
        /// Approval decision: "Approved", "Disapproved", "Pending", etc.
        /// </summary>
        public string? ApprovalStatus { get; set; }
    }
}
