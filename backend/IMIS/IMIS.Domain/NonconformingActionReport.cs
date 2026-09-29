using System;
using System.Collections.Generic;
using Base.Primitives;

namespace IMIS.Domain
{
    public class NonconformingActionReport : Entity<long>
    {
        // Header Details
        public required string ReferenceNumber { get; set; }
        public required string Office { get; set; }
        public required string RelevantStandard { get; set; }
        public DateTime AuditDate { get; set; }

        // Type / Nature of Report
        public bool IsInternalAudit { get; set; }
        public bool IsExternalAudit { get; set; }
        public bool IsNonconformity { get; set; }
        public bool IsInternalCustomer { get; set; }
        public bool IsExternalCustomer { get; set; }
        public bool IsComplaint { get; set; }
        public bool IsResponseRate { get; set; }
        public bool IsOperations { get; set; }

        // Findings
        public required string StandardRequirement { get; set; }
        public required string LegalOrPolicyReference { get; set; }
        public required string AuditFindings { get; set; }

        // Source Audit Report link
        public int? AuditReportId { get; set; }
        public AuditReport? AuditReport { get; set; }

        // Auditor / Auditee Sign-offs (Issuance)
        public required string IssuedByAuditorUserId { get; set; }
        public User? IssuedByAuditor { get; set; }
        public DateTime? IssuedDate { get; set; }

        public required string AcknowledgedByAuditeeUserId { get; set; }
        public User? AcknowledgedByAuditee { get; set; }
        public DateTime? AcknowledgedDate { get; set; }

        // Root Cause Analysis
        public ICollection<NcarRootCause> RootCauses { get; set; } = new List<NcarRootCause>();

        // Action Items
        public ICollection<NcarCorrectionAction> Corrections { get; set; } = new List<NcarCorrectionAction>();
        public ICollection<NcarCorrectiveAction> CorrectiveActions { get; set; } = new List<NcarCorrectiveAction>();

        // Proposed Action Approval
        public string? ProposedByAuditeeUserId { get; set; }
        public User? ProposedByAuditee { get; set; }
        public DateTime? ProposedDate { get; set; }

        public string? ApprovedByHeadUserId { get; set; }
        public User? ApprovedByHead { get; set; }
        public DateTime? ApprovedDate { get; set; }

        // Verification & Closure
        public string? VerificationDetails { get; set; }
        public string? VerifiedByAuditorUserId { get; set; }
        public User? VerifiedByAuditor { get; set; }
        public DateTime? VerifiedDate { get; set; }

        public string? ValidatedByLeadAuditorUserId { get; set; }
        public User? ValidatedByLeadAuditor { get; set; }
        public DateTime? ValidatedDate { get; set; }

        // Status
        public bool IsActive { get; set; } = true;
        public bool IsClosed { get; set; } = false;
        public string FormRevision { get; set; } = "QP-03-F-08 Rev. 5";
    }
}
