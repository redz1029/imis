using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ImpactScoreCardIndicatorModule;
using IMIS.Domain;
namespace IMIS.Application.ImpactScoreCardModule
{
    public class ImpactScoreCardDto : BaseDto<ImpactScoreCard, long>
    {
        public string? ImpactDescription { get; set; }
        public long? ImpactStrategicGoalScoreCardId { get; set; }
        public List<ImpactScoreCardIndicatorDto>? ImpactScoreCardIndicator { get; set; }
        public ImpactScoreCardDto() { }
        [SetsRequiredMembers]
        public ImpactScoreCardDto(ImpactScoreCard entity)
        {
            Id = entity.Id;
            ImpactStrategicGoalScoreCardId = entity.ImpactStrategicGoalScoreCardId;
            ImpactScoreCardIndicator = entity.ImpactScoreCardIndicator?
            .Select(d => new ImpactScoreCardIndicatorDto
            {
                Id = d.Id,
                ImpactScoreCardId = d.ImpactScoreCardId,
                IndicatorDescription = d.IndicatorDescription,
            })
            .ToList();
        }

        public override ImpactScoreCard ToEntity()
        {
            return new ImpactScoreCard()
            {
                Id = Id,
                ImpactStrategicGoalScoreCardId = ImpactStrategicGoalScoreCardId,
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