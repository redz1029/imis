using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ImpactStrategicScoreCardTargetModule;
using IMIS.Domain;
namespace IMIS.Application.ImpactStrategicScoreCardMeasureModule
{
    public class ImpactStrategicScoreCardMeasureDto : BaseDto<ImpactStrategicScoreCardMeasure, long>
    {
        public long? ImpactStrategicScoreCardId { get; set; }
        public string? MeasureDescription { get; set; }
        public List<ImpactStrategicScoreCardTargetDto>? ImpactStrategicScoreCardTarget { get; set; }
        public ImpactStrategicScoreCardMeasureDto() { }
        [SetsRequiredMembers]
        public ImpactStrategicScoreCardMeasureDto(ImpactStrategicScoreCardMeasure entity)
        {
            Id = entity.Id;
            ImpactStrategicScoreCardId = entity.ImpactStrategicScoreCardId;
            MeasureDescription = entity.MeasureDescription;
            ImpactStrategicScoreCardTarget = entity.ImpactStrategicScoreCardTarget?
            .Select(d => new ImpactStrategicScoreCardTargetDto
            {
                Id = d.Id,
                ImpactStrategicScoreCardMeasureId = d.ImpactStrategicScoreCardMeasureId,
                Year = d.Year,
                Target = d.Target,
            })
            .ToList();
        }
        public override ImpactStrategicScoreCardMeasure ToEntity()
        {
            return new ImpactStrategicScoreCardMeasure()
            {
                Id = Id,
                ImpactStrategicScoreCardId = ImpactStrategicScoreCardId,
                ImpactStrategicScoreCardTarget = ImpactStrategicScoreCardTarget?
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