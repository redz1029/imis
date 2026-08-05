using Base.Primitives;

namespace IMIS.Domain
{
    public class ImpactScoreCard : Entity<long>
    {
        public string? ImpactDescription { get; set; }  
        public long? ImpactStrategicGoalScoreCardId { get; set; }
        public List<ImpactScoreCardIndicator>? ImpactScoreCardIndicator { get; set; }
    }
}
