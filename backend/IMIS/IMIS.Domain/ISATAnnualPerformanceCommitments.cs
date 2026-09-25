using Base.Primitives;

namespace IMIS.Domain
{
    public class ISATAnnualPerformanceCommitments : Entity<long>
    {
        public long ISATId { get; set; }
        public string? Deliverable { get; set; }
        public string? Target { get; set; }
        public string? TimeLine { get; set; }
        public string? Status { get; set; }
        public string? Accomplishment { get; set; }
    }
}
