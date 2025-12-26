using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapModule
{
    public class ReportKraRoadMapDto : BaseDto<KraRoadMap, long>
    {
        public int? KraId { get; set; }
        public KeyResultAreaDto? Kra { get; set; }
        public string? KraName => Kra?.Name;
        public string? StrategicObjective => Kra?.StrategicObjective;

        public int KraRoadMapPeriodId { get; set; }
        public KraRoadMapPeriodDto? KraRoadMapPeriod { get; set; }

        public List<ReportKraRoadMapDeliverableGroupDto>? Deliverables { get; set; }

        public List<int>? DeliverableYears { get; set; }

        public int? Year1 => DeliverableYears?.ElementAtOrDefault(0);
        public int? Year2 => DeliverableYears?.ElementAtOrDefault(1);
        public int? Year3 => DeliverableYears?.ElementAtOrDefault(2);
        public int? Year4 => DeliverableYears?.ElementAtOrDefault(3);
        public int? Year5 => DeliverableYears?.ElementAtOrDefault(4);
       
        public List<KraRoadMapKpiDto>? Kpis { get; set; }
        public KraRoadMapKpiDto? Kpi1 => Kpis != null && Kpis.Count > 0 ? Kpis[0] : null;
        public KraRoadMapKpiDto? Kpi2 => Kpis != null && Kpis.Count > 1 ? Kpis[1] : null;
        public string? Kpi1Description => Kpi1?.KpiDescription;
        public string? Kpi2Description => Kpi2?.KpiDescription;

        [SetsRequiredMembers]
        public ReportKraRoadMapDto(KraRoadMap entity)
        {
            Id = entity.Id;
            KraId = entity.KraId;
            KraRoadMapPeriodId = entity.KraRoadMapPeriodId;

            Kra = entity.Kra != null ? new KeyResultAreaDto(entity.Kra) : null;
            KraRoadMapPeriod = entity.KraRoadMapPeriod != null
                ? new KraRoadMapPeriodDto(entity.KraRoadMapPeriod)
                : null;

            DeliverableYears = entity.Deliverables?
                .Select(d => d.Year)
                .Distinct()
                .OrderBy(y => y)
                .ToList();

            Deliverables = entity.Deliverables?
                .GroupBy(d => d.KraDescription)
                .Select(g => new ReportKraRoadMapDeliverableGroupDto(
                    items: g.ToList(),
                    allYears: DeliverableYears
                ))
                .ToList();

            Kpis = entity.Kpis?.Select(k => new KraRoadMapKpiDto(k)).ToList();
        }

        public override KraRoadMap ToEntity()
        {
            return new KraRoadMap
            {
                Id = Id,
                KraId = KraId,
                KraRoadMapPeriodId = KraRoadMapPeriodId,
                Deliverables = Deliverables?.SelectMany(g => g.Items).ToList(),
                Kpis = Kpis?.Select(k => k.ToEntity()).ToList()
            };
        }
    }
}







