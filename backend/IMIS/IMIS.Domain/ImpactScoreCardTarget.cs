using Base.Primitives;

namespace IMIS.Domain
{
    public class ImpactScoreCardTarget : Entity<long>
    {
        public long? ImpactScoreCardIndicatorId { get; set; }
        public int? Year { get; set; }
        public string? Target { get; set; }
    }
}
