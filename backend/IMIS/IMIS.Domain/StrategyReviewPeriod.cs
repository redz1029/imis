using Base.Primitives;

namespace IMIS.Domain
{
    public class StrategyReviewPeriod : Entity<int>
    {
        public required DateOnly StartDate { get; set; }
        public required DateOnly EndDate { get; set; }
        public string? Quarter { get; set; }
    }
}
