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
    public class PerformanceValidationToolDto : BaseDto<PerformanceValidationTool, long>
    {
        public int PerformanceValidationToolPeriodId { get; set; }
        public PerformanceValidationToolPeriodDto? Period { get; set; }   
        public int? OfficeId { get; set; }
        public OfficeDto? Office { get; set; }
        public string? OfficeHeadUserId { get; set; }
        public string? OfficeHeadName { get; set; }
        public DateTime? ValidateDate { get; set; }
        public string? Comment { get; set; }
        public DateTime? PostingDate { get; set; }
        public List<PerformanceValidationToolValidatorsDto>? Validators { get; set; }
        public PerformanceValidationToolObjectivesDto? Objectives { get; set; }
        public List<PerformanceValidationToolDeliverableFindingsDto>? DeliverableFindings { get; set; }
        public PerformanceValidationToolConclusionDto? Conclusion { get; set; }
        public List<PerformanceValidationToolSignatoryDto>? PvtSignatories { get; set; }
        public bool IsDraft { get; set; }

        public long? PerformanceGovernanceSystemId { get; set; }     

        public PerformanceValidationToolDto(){}
        [SetsRequiredMembers]

        public PerformanceValidationToolDto(PerformanceValidationTool entity)
        {
            Id = entity.Id;
            PerformanceValidationToolPeriodId = entity.PerformanceValidationToolPeriodId;
            Period = entity.PerformanceValidationToolPeriod == null ? null : new PerformanceValidationToolPeriodDto(entity.PerformanceValidationToolPeriod);
            OfficeId = entity.OfficeId;
            Office = entity.Office == null ? null : new OfficeDto(entity.Office);
            OfficeHeadUserId = entity.OfficeHeadUserId;
            ValidateDate = entity.ValidateDate;
            Comment = entity.Comment;
            PostingDate = entity.PostingDate;
            Objectives = entity.Objectives == null ? null : new PerformanceValidationToolObjectivesDto(entity.Objectives);
            Conclusion = entity.Conclusion == null ? null : new PerformanceValidationToolConclusionDto(entity.Conclusion);
            Validators = entity.Validators?.Select(x => new PerformanceValidationToolValidatorsDto(x)).ToList();
            DeliverableFindings = entity.DeliverableFindings?.Select(x => new PerformanceValidationToolDeliverableFindingsDto(x)).ToList();
            PvtSignatories = entity.PvtSignatories?.Select(x => new PerformanceValidationToolSignatoryDto
            {
                Id = x.Id,
                PerformanceValidationToolId = x.PerformanceValidationToolId,
                PerformanceValidationToolSignatoryTemplateId = x.PerformanceValidationToolSignatoryTemplateId,
                SignatoryId = x.SignatoryId,                
                DateSigned = x.DateSigned,
              
            })
            .ToList();
            PerformanceGovernanceSystemId = entity.PerformanceGovernanceSystemId;
        }

        public override PerformanceValidationTool ToEntity()
        {
            return new PerformanceValidationTool
            {
                Id = Id,
                PerformanceValidationToolPeriodId = PerformanceValidationToolPeriodId,
                OfficeId = OfficeId,
                OfficeHeadUserId = OfficeHeadUserId ?? string.Empty,
                ValidateDate = ValidateDate,
                Comment = Comment,
                PostingDate = PostingDate,
                Objectives = Objectives?.ToEntity(),
                Conclusion = Conclusion?.ToEntity(),
                Validators = Validators?.Select(x => x.ToEntity()).ToList(),
                DeliverableFindings = DeliverableFindings?.Select(x => x.ToEntity()).ToList(),
                PvtSignatories = PvtSignatories?.Select(x => x.ToEntity()).ToList(),
                PerformanceGovernanceSystemId = PerformanceGovernanceSystemId,
            };
        }
    }
}