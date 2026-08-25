using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PerformanceValidationToolConclusionModule;
using IMIS.Application.PerformanceValidationToolDeliverableFindingsModule;
using IMIS.Application.PerformanceValidationToolObjectivesModule;
using IMIS.Application.PerformanceValidationToolPeriodModule;
using IMIS.Application.PerformanceValidationToolSignatoryModule;
using IMIS.Application.PerformanceValidationToolValidatorsModule;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolModule
{
    public class ReportPerformanceValidationToolDto : BaseDto<PerformanceValidationTool, long>
    {
        public PerformanceValidationToolPeriodDto? Period { get; set; }
        public string? PeriodCovered => Period == null ? null : $"{Period.StartDate:MMMM} to {Period.EndDate:MMMM yyyy}";

        public OfficeDto? Office { get; set; }
        public string? OfficeName => Office?.Name;

        public string? OfficeHeadUserId { get; set; }
        public string? OfficeHeadName { get; set; }

        public DateTime? ValidateDate { get; set; }
        public string? Comment { get; set; }
        public DateTime? PostingDate { get; set; }

        public List<PerformanceValidationToolValidatorsDto>? Validators { get; set; }

        public string? Validator1 => Validators?.ElementAtOrDefault(0)?.AuditorName;
        public string? Validator2 => Validators?.ElementAtOrDefault(1)?.AuditorName;
        public string? Validator3 => Validators?.ElementAtOrDefault(2)?.AuditorName;
        public string? Validator4 => Validators?.ElementAtOrDefault(3)?.AuditorName;
        public string? Validator5 => Validators?.ElementAtOrDefault(4)?.AuditorName;
        public string? Validator6 => Validators?.ElementAtOrDefault(5)?.AuditorName;

        public PerformanceValidationToolObjectivesDto? Objectives { get; set; }
        public string? IsAssessmentCompliant => Objectives?.IsAssessmentCompliant switch
        {
            true => "Yes", false => "No", _ => null
        };

        public string? IsImplementationVerified => Objectives?.IsImplementationVerified switch
        {
            true => "Yes", false => "No", _ => null
        };

        public string? IsDeliverableProgressMonitored => Objectives?.IsDeliverableProgressMonitored switch
        {
            true => "Yes", false => "No", _ => null
        };

        public string? HasOpportunitiesForImprovement => Objectives?.HasOpportunitiesForImprovement switch
        {
            true => "Yes", false => "No", _ => null
        };

        public string? IsValidated =>  Objectives?.IsValidated switch
        {
            true => "Yes", false => "No", _ => null
        };


        public List<PerformanceValidationToolDeliverableFindingsDto>? DeliverableFindings { get; set; }

        public PerformanceValidationToolConclusionDto? Conclusion { get; set; }

        public string? IsCompliant => Conclusion?.IsCompliant switch
        {
            true => "Yes", false => "No", _ => null
        };
        public string? IsImprovement => Conclusion?.IsImprovement switch
        {
            true => "Yes", false => "No", _ => null
        };
        public string? IsPartial => Conclusion?.IsPartial switch
        {
            true => "Yes", false => "No", _ => null
        };
        public string? IsCritical => Conclusion?.IsCritical switch
        {
            true => "Yes", false => "No", _ => null
        };
     
        public List<PerformanceValidationToolSignatoryDto>? PvtSignatories { get; set; }

        public string? Signatory1 => PvtSignatories?.ElementAtOrDefault(0)?.SignatoryName;
        public string? Signatory2 => PvtSignatories?.ElementAtOrDefault(1)?.SignatoryName;
        public string? Signatory3 => PvtSignatories?.ElementAtOrDefault(2)?.SignatoryName;
     
        public DateTime? Signatory1DateSigned => PvtSignatories?.ElementAtOrDefault(0)?.DateSigned;
        public DateTime? Signatory2DateSigned => PvtSignatories?.ElementAtOrDefault(1)?.DateSigned;
        public DateTime? Signatory3DateSigned => PvtSignatories?.ElementAtOrDefault(2)?.DateSigned;
    
        public bool IsDraft { get; set; }

        public long? PerformanceGovernanceSystemId { get; set; }

        public ReportPerformanceValidationToolDto()
        {
        }

        [SetsRequiredMembers]
        public ReportPerformanceValidationToolDto(PerformanceValidationTool entity)
        {
            Id = entity.Id;
            Period = entity.PerformanceValidationToolPeriod == null ? null : new PerformanceValidationToolPeriodDto(entity.PerformanceValidationToolPeriod);
            Office = entity.Office == null ? null : new OfficeDto(entity.Office);
            OfficeHeadUserId = entity.OfficeHeadUserId;
            ValidateDate = entity.ValidateDate;
            Comment = entity.Comment;
            PostingDate = entity.PostingDate;
            Objectives = entity.Objectives == null ? null : new PerformanceValidationToolObjectivesDto(entity.Objectives);
            Conclusion = entity.Conclusion == null ? null : new PerformanceValidationToolConclusionDto(entity.Conclusion);
            Validators = entity.Validators?.OrderBy(x => x.Id).Select(x => new PerformanceValidationToolValidatorsDto
            {
                Id = x.Id,
                PerformanceValidationToolId = x.PerformanceValidationToolId,
                AuditorId = x.AuditorId,
                AuditorName = string.Join(" ", new[]
                {
                    x.Auditor?.User?.FirstName,
                    x.Auditor?.User?.MiddleName,
                    x.Auditor?.User?.LastName,
                    x.Auditor?.User?.Suffix
                }.Where(s => !string.IsNullOrWhiteSpace(s))),
                PostingDate = x.PostingDate,
                IsDeleted = x.IsDeleted,
                RowVersion = x.RowVersion
            })
            .ToList();
            DeliverableFindings = entity.DeliverableFindings!.Select(x => new PerformanceValidationToolDeliverableFindingsDto
            {
                Id = x.Id,
                PerformanceValidationToolId = x.PerformanceValidationToolId,
                PgsDeliverableId = x.PgsDeliverableId,
                DeliverableName = x.PgsDeliverable?.DeliverableName,
                Findings = x.Findings,
                IsNC = x.IsNC,
                IsOFI = x.IsOFI,
                PostingDate = x.PostingDate,
                IsDeleted = x.IsDeleted,
                RowVersion = x.RowVersion
            })
            .ToList();         
            PvtSignatories = entity.PvtSignatories?.OrderBy(x => x.PerformanceValidationToolSignatoryTemplate?.OrderLevel ?? 0).ThenBy(x => x.Id).Select(x => new PerformanceValidationToolSignatoryDto
            {
                Id = x.Id,
                PerformanceValidationToolId = x.PerformanceValidationToolId,
                PerformanceValidationToolSignatoryTemplateId = x.PerformanceValidationToolSignatoryTemplateId,
                SignatoryId = x.SignatoryId,
                SignatoryName = string.Join(" ", new[]
                {
                    x.Signatory?.FirstName,
                    x.Signatory?.MiddleName,
                    x.Signatory?.LastName,
                    x.Signatory?.Suffix
                }.Where(s => !string.IsNullOrWhiteSpace(s))),
                OrderLevel = x.PerformanceValidationToolSignatoryTemplate?.OrderLevel ?? 0,
                DateSigned = x.DateSigned
            })
            .ToList();
            PerformanceGovernanceSystemId = entity.PerformanceGovernanceSystemId;
        }

        public override PerformanceValidationTool ToEntity()
        {
            return new PerformanceValidationTool
            {
                Id = Id,
                OfficeHeadUserId = OfficeHeadUserId ?? string.Empty,
                ValidateDate = ValidateDate,
                Comment = Comment,
                PostingDate = PostingDate,
                Objectives = Objectives?.ToEntity(),
                Conclusion = Conclusion?.ToEntity(),
                Validators = Validators?.Select(x => x.ToEntity()).ToList(),
                DeliverableFindings = DeliverableFindings?.Select(x => x.ToEntity()).ToList(),
                PvtSignatories = PvtSignatories?.Select(x => x.ToEntity()).ToList(),
                PerformanceGovernanceSystemId = PerformanceGovernanceSystemId
            };
        }
    }
}