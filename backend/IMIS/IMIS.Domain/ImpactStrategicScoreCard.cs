using Base.Primitives;

namespace IMIS.Domain
{
    public class ImpactStrategicScoreCard : Entity<long>
    {
        public string? GoalDescription { get; set; }    
        public long ImpactStrategicGoalScoreCardId { get; set; }
        public List<ImpactStrategicScoreCardMeasure>? ImpactStrategicScoreCardMeasure { get; set; }
    }
}
