using Base.Primitives;

namespace IMIS.Domain
{
    public class NcarCorrectiveAction : Entity<long>
    {
        public required long NonconformingActionReportId { get; set; }
        public NonconformingActionReport? NonconformingActionReport { get; set; }
        public required string ActionDescription { get; set; }
        public int OrderNumber { get; set; }
    }
}
