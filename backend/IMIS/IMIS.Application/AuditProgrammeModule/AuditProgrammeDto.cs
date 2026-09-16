using Base.Primitives;
using IMIS.Application.AuditPlanApprovalModule;
using IMIS.Application.AuditPlanModule;
using IMIS.Application.AuditProgrammeStatusHistoryModule;
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

        // Read-only. NEVER mapped in ToEntity() — status only changes
        // through AuditProgrammeService.SubmitAsync / DecideAsync.
        public int AuditStatusId { get; set; }
        public string? StatusCode { get; set; }
        public string? StatusName { get; set; }
        public List<AuditProgrammeStatusHistoryDto> StatusHistory { get; set; } = new();

        // The AuditPlanApproval rows belonging to this programme
        // (AuditProgrammeId set, AuditPlanId null on each).
        public List<AuditPlanApprovalDto> Approvals { get; set; } = new();

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

            AuditStatusId = entity.AuditStatusId;
            StatusCode = entity.AuditStatus?.Code;
            StatusName = entity.AuditStatus?.Name;

            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            if (entity.StatusHistory != null && entity.StatusHistory.Any())
            {
                StatusHistory = entity.StatusHistory
                    .OrderBy(h => h.ChangedDate)
                    .Select(h => new AuditProgrammeStatusHistoryDto
                    {
                        Id = h.Id,
                        StatusCode = h.AuditStatus?.Code ?? string.Empty,
                        StatusName = h.AuditStatus?.Name ?? string.Empty,
                        ChangedDate = h.ChangedDate,
                        Remarks = h.Remarks
                    })
                    .ToList();
            }

            if (entity.Approvals != null && entity.Approvals.Any())
            {
                Approvals = entity.Approvals
                    .OrderBy(a => a.Timestamp)
                    .Select(a => new AuditPlanApprovalDto
                    {
                        Id = a.Id,
                        ApproverId = a.ApproverId,
                        ApproverName = a.Approver?.UserName,
                        Action = a.Action,
                        Timestamp = a.Timestamp,
                        Comments = a.Comments
                    })
                    .ToList();
            }

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

                // AuditStatusId intentionally NOT mapped — see SubmitAsync/DecideAsync.

                IsDeleted = IsDeleted,
                RowVersion = RowVersion,

                Objectives = Objectives?.Select(o => o.ToEntity()).ToList() ?? new List<AuditProgrammeObjective>(),
                AuditPlans = AuditPlans?.Select(p => p.ToEntity()).ToList() ?? new List<AuditPlan>()
            };
        }
    }
}