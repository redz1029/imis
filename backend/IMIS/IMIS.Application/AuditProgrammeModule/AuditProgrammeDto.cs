using Base.Primitives;
using IMIS.Application.AuditPlanModule;
using IMIS.Application.IQASignatoryModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text.Json.Serialization;

namespace IMIS.Application.AuditProgrammeModule
{
    public class AuditProgrammeDto : BaseDto<AuditProgramme, int>
    {
        public int Year { get; set; }
        public required string For { get; set; }
        public required string From { get; set; }
        public required string Purpose { get; set; }
        public required string ScopeAndFreqAudit { get; set; }
        public required string InternalAuditSched { get; set; }
        public required string AuditPlanObjective { get; set; }
        public required string ScopeOfAudit { get; set; }

        public required string AuditCriteria { get; set; }
        public required string AuditMethodology { get; set; }
        public required string SelectionAndEvaluationOfAuditors { get; set; }
        public required string Reporting { get; set; }
        public required string VerificationOfPreviousNonconformities { get; set; }
        public required string AuditLimitations { get; set; }

        // Read-only, derived from the IQA signatory rows (DRAFT / PENDING /
        // APPROVED / DISAPPROVED). NEVER mapped in ToEntity() — the state only
        // changes through AuditProgrammeService.SubmitAsync / DecideAsync.
        public string? StatusCode { get; set; }
        public string? StatusName { get; set; }

        // Live approval chain, in signing order.
        public List<IQASignatoryDto> Signatories { get; set; } = new();

        // Persistent approval & rejection history
        public List<IQAApprovalHistoryDto> ApprovalHistory { get; set; } = new();
        public RejectionDetailsDto? LatestRejection { get; set; }

        public List<AuditProgrammeObjectiveDto> Objectives { get; set; } = new();

        [JsonPropertyName("combinedObjectivesText")]
        public string CombinedObjectivesText { get; set; } = string.Empty;

        [JsonPropertyName("auditPlan")]
        public List<AuditPlanDto> AuditPlans { get; set; } = new();

        public AuditProgrammeDto() { }

        [SetsRequiredMembers]
        public AuditProgrammeDto(AuditProgramme entity)
        {
            Id = entity.Id;
            Year = entity.Year;
            For = entity.For;
            From = entity.From;
            Purpose = entity.Purpose;
            ScopeAndFreqAudit = entity.ScopeAndFreqAudit;
            InternalAuditSched = entity.InternalAuditSched;
            AuditPlanObjective = entity.AuditPlanObjective;
            ScopeOfAudit = entity.ScopeOfAudit;

            AuditCriteria = entity.AuditCriteria;
            AuditMethodology = entity.AuditMethodology;
            SelectionAndEvaluationOfAuditors = entity.SelectionAndEvaluationOfAuditors;
            Reporting = entity.Reporting;
            VerificationOfPreviousNonconformities = entity.VerificationOfPreviousNonconformities;
            AuditLimitations = entity.AuditLimitations;

            // Callers must load IQASignatories (non-deleted) or this reads as Draft.
            var signatories = IQAApprovalWorkflow.Ordered(entity.IQASignatories);
            var stateCode = IQAApprovalWorkflow.DeriveStateCode(signatories, IQAApprovalWorkflow.EntityTypes.AuditProgramme);
            StatusCode = stateCode;
            StatusName = IQAApprovalWorkflow.StateName(stateCode, IQAApprovalWorkflow.EntityTypes.AuditProgramme);
            Signatories = signatories.Select(s => new IQASignatoryDto(s)).ToList();

            if (entity.ApprovalHistories != null && entity.ApprovalHistories.Any())
            {
                ApprovalHistory = entity.ApprovalHistories
                    .Where(h => !h.IsDeleted)
                    .OrderBy(h => h.ActionDate)
                    .Select(h => new IQAApprovalHistoryDto(h))
                    .ToList();

                var lastRej = entity.ApprovalHistories
                    .Where(h => !h.IsDeleted && (h.Action == IQAApprovalWorkflow.Actions.Rejected || h.Status == "Revision Required"))
                    .OrderByDescending(h => h.ActionDate)
                    .FirstOrDefault();

                if (lastRej != null)
                {
                    LatestRejection = new RejectionDetailsDto
                    {
                        RejectedBy = FullNameOf(lastRej.User),
                        RejectedByUserId = lastRej.UserId,
                        RejectedDate = lastRej.ActionDate,
                        RejectionReason = lastRej.Comments,
                        OfficeName = lastRej.OfficeName,
                        RoleOrPosition = lastRej.RoleOrPosition
                    };
                }
            }

            if (LatestRejection == null)
            {
                var rejectedSig = signatories.FirstOrDefault(s =>
                    s.ApprovalStatus == IQAApprovalWorkflow.Decisions.Rejected ||
                    s.ApprovalStatus == IQAApprovalWorkflow.Decisions.Disapproved);
                if (rejectedSig != null)
                {
                    LatestRejection = new RejectionDetailsDto
                    {
                        RejectedBy = FullNameOf(rejectedSig.Signatory),
                        RejectedByUserId = rejectedSig.SignatoryId,
                        RejectedDate = rejectedSig.DateSigned,
                        RejectionReason = rejectedSig.Remarks,
                        RoleOrPosition = rejectedSig.IQASignatoryTemplate?.SignatoryLabel
                    };
                }
            }

            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            if (entity.Objectives != null && entity.Objectives.Any())
            {
                Objectives = entity.Objectives
                    .OrderBy(o => o.SortOrder)
                    .Select(o => new AuditProgrammeObjectiveDto(o))
                    .ToList();

                CombinedObjectivesText = string.Join(Environment.NewLine, entity.Objectives
                    .OrderBy(o => o.SortOrder)
                    .Select(o => o.Description));
            }

            if (entity.AuditPlans != null)
            {
                AuditPlans = entity.AuditPlans
                    .Select(p => new AuditPlanDto(p))
                    .ToList();
            }
        }

        private static string? FullNameOf(User? user)
        {
            if (user == null) return null;
            var parts = new[] { user.Prefix, user.FirstName, user.MiddleName, user.LastName, user.Suffix }
                .Where(p => !string.IsNullOrWhiteSpace(p));
            var full = string.Join(" ", parts);
            return string.IsNullOrWhiteSpace(full) ? user.UserName : full;
        }

        public override AuditProgramme ToEntity()
        {
            return new AuditProgramme
            {
                Id = Id,
                Year = Year,
                For = For,
                From = From,
                Purpose = Purpose,
                ScopeAndFreqAudit = ScopeAndFreqAudit,
                InternalAuditSched = InternalAuditSched,
                AuditPlanObjective = AuditPlanObjective,
                ScopeOfAudit = ScopeOfAudit,
                AuditCriteria = AuditCriteria,
                AuditMethodology = AuditMethodology,
                SelectionAndEvaluationOfAuditors = SelectionAndEvaluationOfAuditors,
                Reporting = Reporting,
                VerificationOfPreviousNonconformities = VerificationOfPreviousNonconformities,
                AuditLimitations = AuditLimitations,

                IsDeleted = IsDeleted,
                RowVersion = RowVersion,

                Objectives = Objectives?.Select(o => o.ToEntity()).ToList() ?? new List<AuditProgrammeObjective>(),
                AuditPlans = AuditPlans?.Select(p => p.ToEntity()).ToList() ?? new List<AuditPlan>()
            };
        }
    }
}