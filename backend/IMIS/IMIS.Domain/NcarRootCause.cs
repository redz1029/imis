using Base.Primitives;

namespace IMIS.Domain
{
    public class NcarRootCause : Entity<long>
    {
        public required long NonconformingActionReportId { get; set; }
        public NonconformingActionReport? NonconformingActionReport { get; set; }
        public required string CauseDescription { get; set; }
        public int OrderNumber { get; set; }
    }
}
