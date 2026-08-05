using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.ImpactStrategicScoreCardTargetModule
{
    public class ImpactStrategicScoreCardTargetDto : BaseDto<ImpactStrategicScoreCardTarget, long>
    {
        public long? ImpactStrategicScoreCardMeasureId { get; set; }
        public int? Year { get; set; }
        public string? Target { get; set; }
        public ImpactStrategicScoreCardTargetDto()
        {
        }

        [SetsRequiredMembers]
        public ImpactStrategicScoreCardTargetDto(ImpactStrategicScoreCardTarget entity)
        {
            Id = entity.Id;
            ImpactStrategicScoreCardMeasureId = entity.ImpactStrategicScoreCardMeasureId;
            Year = entity.Year;
            Target = entity.Target;
        }

        public override ImpactStrategicScoreCardTarget ToEntity()
        {
            return new ImpactStrategicScoreCardTarget()
            {
                Id = Id,
                ImpactStrategicScoreCardMeasureId = ImpactStrategicScoreCardMeasureId,
                Year = Year,
                Target = Target
            };
        }      
    }
}
