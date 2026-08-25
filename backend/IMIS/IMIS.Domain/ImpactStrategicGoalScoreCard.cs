using Base.Primitives;

namespace IMIS.Domain
{
    public class ImpactStrategicGoalScoreCard : Entity<long>
    {
        public int? ImpactStrategicGoalScoreCardPeriodId { get; set; }
        public ImpactStrategicGoalScoreCardPeriod? ImpactStrategicGoalScoreCardPeriod { get; set; }
        public List<ImpactScoreCard>? ImpactScoreCard { get; set; }
        public List<ImpactStrategicScoreCard>? ImpactStrategicScoreCard { get; set; }
    }
}
