using IMIS.Application.KraRoadMapKpiModule;

namespace IMIS.Application.KraRoadMapModule
{
    public class KraRoadMapKpiDeliverableFilterDto
    {
        public required DateOnly StartDate { get; set; }
        public required DateOnly EndDate { get; set; }
        public List<KraRoadMapKpiDto>? KpiDeliverable { get; set; }
    }
}
