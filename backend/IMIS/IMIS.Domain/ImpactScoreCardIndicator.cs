

using Base.Primitives;

namespace IMIS.Domain
{
    public class ImpactScoreCardIndicator : Entity<long>
    {      
        public long? ImpactScoreCardId { get; set; }
        public string? IndicatorDescription { get; set; }
        public List<ImpactScoreCardTarget>? ImpactScoreCardTarget { get; set; }
    }
}
