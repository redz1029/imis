using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.ImpactScoreCardTargetModule
{
    public class ImpactScoreCardTargetDto : BaseDto<ImpactScoreCardTarget, long>
    {
        public long? ImpactScoreCardIndicatorId { get; set; }
        public int? Year { get; set; }
        public string? Target { get; set; }

        public ImpactScoreCardTargetDto() { }

        [SetsRequiredMembers]
        public ImpactScoreCardTargetDto(ImpactScoreCardTarget entity)
        {
            Id = entity.Id;
            ImpactScoreCardIndicatorId = entity.ImpactScoreCardIndicatorId;   
            Year = entity.Year;
            Target = entity.Target;
        }

        public override ImpactScoreCardTarget ToEntity()
        {
            return new ImpactScoreCardTarget()
            {
                Id = Id,
                ImpactScoreCardIndicatorId = ImpactScoreCardIndicatorId,
                Year = Year,
                Target = Target             
            };
        }     
    }
}
