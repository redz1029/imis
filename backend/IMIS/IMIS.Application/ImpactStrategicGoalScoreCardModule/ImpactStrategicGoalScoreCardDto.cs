using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ImpactScoreCardModule;
using IMIS.Application.ImpactScoreCardIndicatorModule;
using IMIS.Application.ImpactScoreCardTargetModule;
using IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule;
using IMIS.Application.ImpactStrategicScoreCardModule;
using IMIS.Application.ImpactStrategicScoreCardMeasureModule;
using IMIS.Application.ImpactStrategicScoreCardTargetModule;
using IMIS.Domain;

namespace IMIS.Application.ImpactStrategicGoalScoreCardModule
{
    public class ImpactStrategicGoalScoreCardDto : BaseDto<ImpactStrategicGoalScoreCard, long>
    {
        public int? ImpactStrategicGoalScoreCardPeriodId { get; set; }
        public ImpactStrategicGoalScoreCardPeriodDto? ImpactStrategicGoalScoreCardPeriod { get; set; }
        public List<ImpactScoreCardDto>? ImpactScoreCard { get; set; }
        public List<ImpactStrategicScoreCardDto>? ImpactStrategicScoreCard { get; set; }

        public ImpactStrategicGoalScoreCardDto() { }

        [SetsRequiredMembers]
        public ImpactStrategicGoalScoreCardDto(ImpactStrategicGoalScoreCard entity)
        {
            Id = entity.Id;
            ImpactStrategicGoalScoreCardPeriodId = entity.ImpactStrategicGoalScoreCardPeriodId;
            ImpactStrategicGoalScoreCardPeriod = entity.ImpactStrategicGoalScoreCardPeriod != null
            ? new ImpactStrategicGoalScoreCardPeriodDto(entity.ImpactStrategicGoalScoreCardPeriod)
            : null;

            ImpactScoreCard = entity.ImpactScoreCard?
            .Where(d => !d.IsDeleted)
            .Select(d => new ImpactScoreCardDto
            {
                Id = d.Id,
                ImpactDescription = d.ImpactDescription,
                ImpactStrategicGoalScoreCardId = d.ImpactStrategicGoalScoreCardId,
                ImpactScoreCardIndicator = d.ImpactScoreCardIndicator?
                    .Where(i => !i.IsDeleted)
                    .Select(i => new ImpactScoreCardIndicatorDto
                    {
                        Id = i.Id,
                        ImpactScoreCardId = i.ImpactScoreCardId,
                        IndicatorDescription = i.IndicatorDescription,
                        ImpactScoreCardTarget = i.ImpactScoreCardTarget?
                            .Where(t => !t.IsDeleted)
                            .Select(t => new ImpactScoreCardTargetDto
                            {
                                Id = t.Id,
                                ImpactScoreCardIndicatorId = t.ImpactScoreCardIndicatorId,
                                Year = t.Year,
                                Target = t.Target
                            })
                            .ToList()
                    })
                    .ToList()
            })
            .ToList();

            ImpactStrategicScoreCard = entity.ImpactStrategicScoreCard?
            .Where(k => !k.IsDeleted)
            .Select(k => new ImpactStrategicScoreCardDto
            {
                Id = k.Id,
                GoalDescription = k.GoalDescription,
                ImpactStrategicGoalScoreCardId = k.ImpactStrategicGoalScoreCardId,
                ImpactStrategicScoreCardMeasure = k.ImpactStrategicScoreCardMeasure?
                    .Where(m => !m.IsDeleted)
                    .Select(m => new ImpactStrategicScoreCardMeasureDto
                    {
                        Id = m.Id,
                        ImpactStrategicScoreCardId = m.ImpactStrategicScoreCardId,
                        MeasureDescription = m.MeasureDescription,
                        ImpactStrategicScoreCardTarget = m.ImpactStrategicScoreCardTarget?
                            .Where(t => !t.IsDeleted)
                            .Select(t => new ImpactStrategicScoreCardTargetDto
                            {
                                Id = t.Id,
                                ImpactStrategicScoreCardMeasureId = t.ImpactStrategicScoreCardMeasureId,
                                Year = t.Year,
                                Target = t.Target
                            })
                            .ToList()
                    })
                    .ToList()
            })
            .ToList();
        }

        public override ImpactStrategicGoalScoreCard ToEntity()
        {
            return new ImpactStrategicGoalScoreCard()
            {
                Id = Id,
                ImpactStrategicGoalScoreCardPeriodId = ImpactStrategicGoalScoreCardPeriodId,
                ImpactScoreCard = ImpactScoreCard?
                .Select(d =>
                {
                    var entity = d.ToEntity();
                    entity.IsDeleted = false;
                    return entity;
                })
                .ToList(),
                ImpactStrategicScoreCard = ImpactStrategicScoreCard?
                .Select(k =>
                {
                    var entity = k.ToEntity();
                    entity.IsDeleted = false;
                    return entity;
                })
                .ToList(),
            };
        }
    }
}