using System;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.NonconformingActionReportModule
{
    public class NonconformingActionReportDto : BaseDto<NonconformingActionReport, long>
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

        // Auditor / Auditee Sign-offs (Issuance)
        public required string IssuedByAuditorUserId { get; set; }
        public string? IssuedByAuditorName { get; set; }
        public DateTime? IssuedDate { get; set; }

        public required string AcknowledgedByAuditeeUserId { get; set; }
        public string? AcknowledgedByAuditeeName { get; set; }
        public DateTime? AcknowledgedDate { get; set; }

        // Root Cause Analysis
        public ICollection<NcarRootCauseDto> RootCauses { get; set; } = new List<NcarRootCauseDto>();

        // Action Items
        public ICollection<NcarCorrectionActionDto> Corrections { get; set; } = new List<NcarCorrectionActionDto>();
        public ICollection<NcarCorrectiveActionDto> CorrectiveActions { get; set; } = new List<NcarCorrectiveActionDto>();

        // Proposed Action Approval
        public string? ProposedByAuditeeUserId { get; set; }
        public DateTime? ProposedDate { get; set; }

        public string? ApprovedByHeadUserId { get; set; }
        public DateTime? ApprovedDate { get; set; }

        // Verification & Closure
        public string? VerificationDetails { get; set; }
        public string? VerifiedByAuditorUserId { get; set; }
        public DateTime? VerifiedDate { get; set; }

        public string? ValidatedByLeadAuditorUserId { get; set; }
        public DateTime? ValidatedDate { get; set; }

        // Status
        public bool IsActive { get; set; } = true;
        public bool IsClosed { get; set; } = false;
        public string FormRevision { get; set; } = "QP-03-F-08 Rev. 5";

        public NonconformingActionReportDto() { }

        [SetsRequiredMembers]
        public NonconformingActionReportDto(NonconformingActionReport entity)
        {
            Id = entity.Id;
            ReferenceNumber = entity.ReferenceNumber;
            Office = entity.Office;
            RelevantStandard = entity.RelevantStandard;
            AuditDate = entity.AuditDate;

            IsInternalAudit = entity.IsInternalAudit;
            IsExternalAudit = entity.IsExternalAudit;
            IsNonconformity = entity.IsNonconformity;
            IsInternalCustomer = entity.IsInternalCustomer;
            IsExternalCustomer = entity.IsExternalCustomer;
            IsComplaint = entity.IsComplaint;
            IsResponseRate = entity.IsResponseRate;
            IsOperations = entity.IsOperations;

            StandardRequirement = entity.StandardRequirement;
            LegalOrPolicyReference = entity.LegalOrPolicyReference;
            AuditFindings = entity.AuditFindings;

            AuditReportId = entity.AuditReportId;

            IssuedByAuditorUserId = entity.IssuedByAuditorUserId;
            IssuedByAuditorName = entity.IssuedByAuditor?.ToString();
            IssuedDate = entity.IssuedDate;

            AcknowledgedByAuditeeUserId = entity.AcknowledgedByAuditeeUserId;
            AcknowledgedByAuditeeName = entity.AcknowledgedByAuditee?.ToString();
            AcknowledgedDate = entity.AcknowledgedDate;

            ProposedByAuditeeUserId = entity.ProposedByAuditeeUserId;
            ProposedDate = entity.ProposedDate;

            ApprovedByHeadUserId = entity.ApprovedByHeadUserId;
            ApprovedDate = entity.ApprovedDate;

            VerificationDetails = entity.VerificationDetails;
            VerifiedByAuditorUserId = entity.VerifiedByAuditorUserId;
            VerifiedDate = entity.VerifiedDate;

            ValidatedByLeadAuditorUserId = entity.ValidatedByLeadAuditorUserId;
            ValidatedDate = entity.ValidatedDate;

            IsActive = entity.IsActive;
            IsClosed = entity.IsClosed;
            FormRevision = entity.FormRevision;

            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            if (entity.RootCauses != null)
                RootCauses = entity.RootCauses.OrderBy(x => x.OrderNumber).Select(x => new NcarRootCauseDto(x)).ToList();

            if (entity.Corrections != null)
                Corrections = entity.Corrections.OrderBy(x => x.OrderNumber).Select(x => new NcarCorrectionActionDto(x)).ToList();

            if (entity.CorrectiveActions != null)
                CorrectiveActions = entity.CorrectiveActions.OrderBy(x => x.OrderNumber).Select(x => new NcarCorrectiveActionDto(x)).ToList();
        }

        public override NonconformingActionReport ToEntity()
        {
            return new NonconformingActionReport
            {
                Id = Id,
                ReferenceNumber = ReferenceNumber,
                Office = Office,
                RelevantStandard = RelevantStandard,
                AuditDate = AuditDate,

                IsInternalAudit = IsInternalAudit,
                IsExternalAudit = IsExternalAudit,
                IsNonconformity = IsNonconformity,
                IsInternalCustomer = IsInternalCustomer,
                IsExternalCustomer = IsExternalCustomer,
                IsComplaint = IsComplaint,
                IsResponseRate = IsResponseRate,
                IsOperations = IsOperations,

                StandardRequirement = StandardRequirement,
                LegalOrPolicyReference = LegalOrPolicyReference,
                AuditFindings = AuditFindings,

                AuditReportId = AuditReportId,

                IssuedByAuditorUserId = IssuedByAuditorUserId,
                IssuedDate = IssuedDate,

                AcknowledgedByAuditeeUserId = AcknowledgedByAuditeeUserId,
                AcknowledgedDate = AcknowledgedDate,

                ProposedByAuditeeUserId = ProposedByAuditeeUserId,
                ProposedDate = ProposedDate,

                ApprovedByHeadUserId = ApprovedByHeadUserId,
                ApprovedDate = ApprovedDate,

                VerificationDetails = VerificationDetails,
                VerifiedByAuditorUserId = VerifiedByAuditorUserId,
                VerifiedDate = VerifiedDate,

                ValidatedByLeadAuditorUserId = ValidatedByLeadAuditorUserId,
                ValidatedDate = ValidatedDate,

                IsActive = IsActive,
                IsClosed = IsClosed,
                FormRevision = FormRevision,

                IsDeleted = IsDeleted,
                RowVersion = RowVersion,

                RootCauses = RootCauses.Select(x => x.ToEntity()).ToList(),
                Corrections = Corrections.Select(x => x.ToEntity()).ToList(),
                CorrectiveActions = CorrectiveActions.Select(x => x.ToEntity()).ToList()
            };
        }
    }
}
