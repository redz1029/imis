using Base.Primitives;

namespace IMIS.Domain
{
    public class KraRoadMapKpi : Entity<int>
    {
        public long KraRoadMapId { get; set; }
        public string? KpiDescription { get; set; }
        public string? Target { get; set; }
        public string? BaseLine { get; set; }
    }
}
