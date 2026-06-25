using Base.Primitives;

namespace IMIS.Domain
{
    public class PerformanceValidationToolDeliverableFindings : Entity<long>
    {
        public long PerformanceValidationToolId { get; set; }
        public long? PgsDeliverableId { get; set; }
        public PgsDeliverable? PgsDeliverable { get; set; }
        public string? Findings { get; set; }
        public bool? IsNC { get; set; }
        public bool? IsOFI { get; set; }
        public DateTime? PostingDate { get; set; }
    }
}
