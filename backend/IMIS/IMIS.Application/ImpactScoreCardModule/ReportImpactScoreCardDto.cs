using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ImpactScoreCardIndicatorModule;
using IMIS.Domain;

namespace IMIS.Application.ImpactScoreCardModule
{
    public class ReportImpactScoreCardDto : BaseDto<ImpactScoreCard, long>
    {
        public string? ImpactDescription { get; set; }
        public long? ImpactStrategicGoalScoreCardId { get; set; }
        public List<ReportImpactScoreCardIndicatorDto>? ImpactScoreCardIndicator { get; set; }

        public ReportImpactScoreCardDto() { }

        [SetsRequiredMembers]
        public ReportImpactScoreCardDto(ImpactScoreCard entity)
        {
            Id = entity.Id;
            ImpactDescription = entity.ImpactDescription;
            ImpactStrategicGoalScoreCardId = entity.ImpactStrategicGoalScoreCardId;

            ImpactScoreCardIndicator = entity.ImpactScoreCardIndicator?
                .Where(i => !i.IsDeleted)
                .Select(i =>
                {
                    var dto = new ReportImpactScoreCardIndicatorDto(i);
                    dto.ImpactDescription = ImpactDescription; 
                    return dto;
                })
                .ToList();
        }

        public override ImpactScoreCard ToEntity()
        {
            return new ImpactScoreCard()
            {
                Id = Id,
                ImpactStrategicGoalScoreCardId = ImpactStrategicGoalScoreCardId,
                ImpactDescription = ImpactDescription,
                ImpactScoreCardIndicator = ImpactScoreCardIndicator?
                .Select(d =>
                {
                    var entity = d.ToEntity();
                    entity.IsDeleted = false;
                    return entity;
                })
                .ToList(),
            };
        }
    }
}