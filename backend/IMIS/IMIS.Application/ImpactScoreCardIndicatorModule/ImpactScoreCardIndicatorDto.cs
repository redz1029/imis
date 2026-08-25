using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ImpactScoreCardTargetModule;
using IMIS.Domain;
namespace IMIS.Application.ImpactScoreCardIndicatorModule
{
    public class ImpactScoreCardIndicatorDto : BaseDto<ImpactScoreCardIndicator, long>
    {
        public long? ImpactScoreCardId { get; set; }
        public string? IndicatorDescription { get; set; }
        public List<ImpactScoreCardTargetDto>? ImpactScoreCardTarget { get; set; }
        public ImpactScoreCardIndicatorDto() { }
        [SetsRequiredMembers]
        public ImpactScoreCardIndicatorDto(ImpactScoreCardIndicator entity)
        {
            Id = entity.Id;
            ImpactScoreCardId = entity.ImpactScoreCardId;
            ImpactScoreCardTarget = entity.ImpactScoreCardTarget?
            .Select(d => new ImpactScoreCardTargetDto
            {
                Id = d.Id,
                ImpactScoreCardIndicatorId = d.ImpactScoreCardIndicatorId,
                Year = d.Year,
                Target = d.Target,
            })
            .ToList();
        }
        public override ImpactScoreCardIndicator ToEntity()
        {
            return new ImpactScoreCardIndicator()
            {
                Id = Id,
                ImpactScoreCardId = ImpactScoreCardId,
                ImpactScoreCardTarget = ImpactScoreCardTarget?
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