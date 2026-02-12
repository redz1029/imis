using Base.Primitives;

namespace IMIS.Domain
{
    public class KraRoadMapDeliverable : Entity<long>
    {
        public string? KraDescription { get; set; }    
        public string? DeliverableDescription { get; set; }
        public required int Year { get; set; }
        public bool IsEnabler { get; set; }
        public long KraRoadMapId { get; set; }
        public KraRoadMap? KraRoadMap { get; set; }
    }
}
