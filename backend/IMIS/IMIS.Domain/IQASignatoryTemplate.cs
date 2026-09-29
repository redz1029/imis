using Base.Primitives;

namespace IMIS.Domain
{
    /// <summary>
    /// Defines the signatory template for Internal Quality Audit approvals.
    /// Similar to PgsSignatoryTemplate but specific to audit workflow (Programme, Plan, Schedule).
    /// Applies at the office level and defines approval order/hierarchy.
    /// </summary>
    public class IQASignatoryTemplate : Entity<int>
    {
        /// <summary>
        /// Audit entity type: "AuditProgramme", "AuditPlan", or "AuditSchedule"
        /// </summary>
        public required string AuditEntityType { get; set; }

        /// <summary>
        /// Status/Stage: e.g., "Draft", "Pending", "Approved", "Disapproved"
        /// </summary>
        public required string Status { get; set; }

        /// <summary>
        /// Signatory role label: e.g., "QMR", "Lead Auditor", "Department Head"
        /// </summary>
        public required string SignatoryLabel { get; set; }

        /// <summary>
        /// Approval order/level (lower = earlier in approval chain)
        /// </summary>
        public int OrderLevel { get; set; }

        /// <summary>
        /// Optional default signatory user ID for this approval level
        /// </summary>
        public string? DefaultSignatoryId { get; set; }

        /// <summary>
        /// Navigation to default signatory user
        /// </summary>
        public User? DefaultSignatory { get; set; }

        /// <summary>
        /// Is this approval level active/enabled
        /// </summary>
        public bool IsActive { get; set; } = true;

        /// <summary>
        /// Office-specific configuration (each office can have different approval chains)
        /// </summary>
        public int OfficeId { get; set; }

        /// <summary>
        /// Navigation to office
        /// </summary>
        public Office? Office { get; set; }

        /// <summary>
        /// Position/role title required for this signatory
        /// </summary>
        public string? Position { get; set; }
    }
}
