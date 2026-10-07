using Base.Primitives;

namespace IMIS.Domain
{
    public class ISATAnnualPerformanceCommitments : Entity<long>
    {
        public long ISATId { get; set; }
        public long? PgsDeliverableId { get; set; }
        public PgsDeliverable? PgsDeliverable { get; set; }
        public int? KraId { get; set; }
        public KeyResultArea? Kra { get; set; }
        public string? Deliverable { get; set; }
        public string? Target { get; set; }
        public string? Accomplishment { get; set; }
    }
}
