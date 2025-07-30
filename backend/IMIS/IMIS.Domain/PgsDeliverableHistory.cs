using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsDeliverableHistory : Entity<long>
    {
        public long PgsId { get; set; }
        public long DeliverableId { get; set; }
        public string? DeliverableName { get; set; }
        public string? KraDescription { get; set; }
        public long? KraId { get; set; }   
        public string? DisapprovalRemarks { get; set; } 
        public bool IsDisapproved { get; set; }
        public required bool IsDirect { get; set; }
        public required double PercentDeliverables { get; set; }
        public required DateTime ByWhen { get; set; }
        public required PgsStatus Status { get; set; }
        public string? Remarks { get; set; }
        public string? RemovedBy { get; set; }
        public DateTime RemovedAt { get; set; } = DateTime.UtcNow;
    }

}
