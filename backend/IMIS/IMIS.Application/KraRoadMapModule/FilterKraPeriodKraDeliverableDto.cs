using IMIS.Application.KraRoadMapDeliverableModule;

namespace IMIS.Application.KraRoadMapModule
{
    public class FilterKraPeriodKraDeliverableDto 
    {      
        public required DateOnly StartDate { get; set; }
        public required DateOnly EndDate { get; set; }
        public required List<KraRoadMapDeliverableDto> Deliverables { get; set; }
    }
}
