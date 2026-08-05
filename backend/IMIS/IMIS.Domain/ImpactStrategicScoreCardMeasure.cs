using Base.Primitives;

namespace IMIS.Domain
{
    public class ImpactStrategicScoreCardMeasure : Entity<long>
    {
        public long? ImpactStrategicScoreCardId { get; set; }
        public string? MeasureDescription { get; set; }
        public List<ImpactStrategicScoreCardTarget>? ImpactStrategicScoreCardTarget { get; set; }
    }
}
