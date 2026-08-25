using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ImpactStrategicScoreCardMeasureModule;
using IMIS.Domain;

namespace IMIS.Application.ImpactStrategicScoreCardModule
{
    public class ReportImpactStrategicScoreCardDto : BaseDto<ImpactStrategicScoreCard, long>
    {
        public string? GoalDescription { get; set; }
        public long ImpactStrategicGoalScoreCardId { get; set; }
        public List<ReportImpactStrategicScoreCardMeasureDto>? ImpactStrategicScoreCardMeasure { get; set; }

        public ReportImpactStrategicScoreCardDto() { }

        [SetsRequiredMembers]
        public ReportImpactStrategicScoreCardDto(ImpactStrategicScoreCard entity)
        {
            Id = entity.Id;
            ImpactStrategicGoalScoreCardId = entity.ImpactStrategicGoalScoreCardId;
            GoalDescription = entity.GoalDescription;

            ImpactStrategicScoreCardMeasure = entity.ImpactStrategicScoreCardMeasure?
                .Where(d => !d.IsDeleted)
                .Select(d =>
                {
                    var dto = new ReportImpactStrategicScoreCardMeasureDto(d);
                    dto.GoalDescription = GoalDescription; 
                    return dto;
                })
                .ToList();
        }

        public override ImpactStrategicScoreCard ToEntity()
        {
            return new ImpactStrategicScoreCard()
            {
                Id = Id,
                ImpactStrategicGoalScoreCardId = ImpactStrategicGoalScoreCardId,
                GoalDescription = GoalDescription,
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