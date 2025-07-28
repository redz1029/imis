using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsDeliverableHistory : Entity<long>
    {
        public long PgsId { get; set; }
        public long DeliverableId { get; set; }
        public string? DeliverableTitle { get; set; }
        public string? Description { get; set; }
        public long? KraId { get; set; }    
        public string? KraName { get; set; }
        public string? RemovedBy { get; set; }
        public DateTime RemovedAt { get; set; } = DateTime.UtcNow;
    }

}
