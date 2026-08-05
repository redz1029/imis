using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ImpactStrategicScoreCardMeasureModule;
using IMIS.Domain;
namespace IMIS.Application.ImpactStrategicScoreCardModule
{
    public class ImpactStrategicScoreCardDto : BaseDto<ImpactStrategicScoreCard, long>
    {
        public string? GoalDescription { get; set; }
        public long ImpactStrategicGoalScoreCardId { get; set; }
        public List<ImpactStrategicScoreCardMeasureDto>? ImpactStrategicScoreCardMeasure { get; set; }
        public ImpactStrategicScoreCardDto() { }
        [SetsRequiredMembers]
        public ImpactStrategicScoreCardDto(ImpactStrategicScoreCard entity)
        {
            Id = entity.Id;
            ImpactStrategicGoalScoreCardId = entity.ImpactStrategicGoalScoreCardId;
            ImpactStrategicScoreCardMeasure = entity.ImpactStrategicScoreCardMeasure?
            .Select(d => new ImpactStrategicScoreCardMeasureDto
            {
                Id = d.Id,
                ImpactStrategicScoreCardId = d.ImpactStrategicScoreCardId,
                MeasureDescription = d.MeasureDescription,
            })
            .ToList();
        }
        public override ImpactStrategicScoreCard ToEntity()
        {
            return new ImpactStrategicScoreCard()
            {
                Id = Id,
                ImpactStrategicGoalScoreCardId = ImpactStrategicGoalScoreCardId,
                ImpactStrategicScoreCardMeasure = ImpactStrategicScoreCardMeasure?
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