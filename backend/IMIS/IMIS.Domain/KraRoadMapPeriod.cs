using Base.Primitives;

namespace IMIS.Domain
{
    public class KraRoadMapPeriod : Entity<int>
    {
        public required DateOnly StartYear { get; set; }
        public required DateOnly EndYear { get; set; }
    }
}
