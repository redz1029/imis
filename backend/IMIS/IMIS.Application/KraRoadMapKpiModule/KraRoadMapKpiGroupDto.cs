using Base.Primitives;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace IMIS.Application.KraRoadMapKpiModule
{
    public class KraRoadMapKpiGroupDto : BaseDto<KraRoadMapKpi, int>
    {
        public string? KpiDescription { get; set; }
        public string? Sequence { get; set; }
        public List<KraRoadMapKpi>? Items { get; set; }

        public KraRoadMapKpiGroupDto() { }
        public KraRoadMapKpiGroupDto(KraRoadMapKpi kpi)
        {
            Id = kpi.Id;
            KpiDescription = kpi.KpiDescription;
            Sequence = kpi.KraRoadmapKpiSequence?.SequenceCode;
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
