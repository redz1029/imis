using Base.Primitives;

namespace IMIS.Domain
{
    public class ISATStrategicObjectiveSupported : Entity<long>
    {
        public long ISATId { get; set; }
        public long? KraRoadMapId { get; set; }
        public KraRoadMap? KraRoadMap { get; set; }
        public long? KraRoadMapDeliverableId { get; set; }
        public KraRoadMapDeliverable? KraRoadMapDeliverable { get; set; }
        public DateTime? PostingDate { get; set; }
    }
}
