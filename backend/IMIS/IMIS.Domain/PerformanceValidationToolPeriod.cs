using Base.Primitives;

namespace IMIS.Domain
{
    public class PerformanceValidationToolPeriod : Entity<int>
    {
        public required DateOnly StartDate { get; set; }
        public required DateOnly EndDate { get; set; }
        public string? Period { get; set; }
    }
}
