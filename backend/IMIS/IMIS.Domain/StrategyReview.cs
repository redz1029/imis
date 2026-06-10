using Base.Primitives;

namespace IMIS.Domain
{
    public class StrategyReview : Entity<long>
    {
        public int StrategyReviewPeriodId { get; set; }
        public StrategyReviewPeriod StrategyReviewPeriod { get; set; } = null!;
        public DateTime PostingDate { get; set; }
        public long KraRoadMapId { get; set; }
        public  KraRoadMap? KraRoadMap { get; set; }
        public List<StrategyReviewDeliverableKpi>? StrategyReviewDeliverableKpi { get; set; }
        public List<StrategyReviewDeliverable>? StrategyReviewDeliverable { get; set; }
        public string? Continue { get; set; }
        public string? Start { get; set; }
        public string? Stop { get; set; }
    }
}
