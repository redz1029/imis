using Base.Primitives;

namespace IMIS.Domain
{
    public class StrategyReviewDeliverable : Entity<long>
    {
        public long StrategyReviewId { get; set; }
        public long KraRoadmapid { get; set; }
        public string? KeyResultArea { get; set; }
        public string? Deliverable { get; set; }
        public string? ActualDate { get; set; }
        public required PgsStatus Status { get; set; }
    }
}
