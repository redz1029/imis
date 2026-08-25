using Base.Primitives;

namespace IMIS.Domain
{
    public class StrategyReviewDeliverableKpi : Entity<long>
    {              
        public long StrategyReviewId { get; set; }      
        public long KraRoadmapid { get; set; }
        public string? Measure { get; set; }
        public string? Target { get; set; }
        public string? ActualDate { get; set; }  
        public required PgsStatus Status { get; set; }
    }
}
