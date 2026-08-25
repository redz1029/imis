using Base.Primitives;

namespace IMIS.Domain
{
    public class ImpactStrategicScoreCardTarget : Entity<long>
    {
        public long? ImpactStrategicScoreCardMeasureId { get; set; }
        public int? Year { get; set; }
        public string? Target { get; set; }
    }
}
