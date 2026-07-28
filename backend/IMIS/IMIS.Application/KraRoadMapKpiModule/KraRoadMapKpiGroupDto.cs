using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapKpiModule
{
    public class KraRoadMapKpiGroupDto : BaseDto<KraRoadMapKpi, int>
    {
        public string? KpiDescription { get; set; }
        public List<KraRoadMapKpi>? Items { get; set; }

        public KraRoadMapKpiGroupDto() { }
        public KraRoadMapKpiGroupDto(KraRoadMapKpi kpi)
        {
            Id = kpi.Id;
            KpiDescription = kpi.KpiDescription;
            Items = new List<KraRoadMapKpi> { kpi };
        }
        public override KraRoadMapKpi ToEntity()
        {
            if (Items == null || Items.Count == 0)
                throw new InvalidOperationException("Cannot convert to entity because Items list is empty.");

            return Items[0];
        }
    }
}
