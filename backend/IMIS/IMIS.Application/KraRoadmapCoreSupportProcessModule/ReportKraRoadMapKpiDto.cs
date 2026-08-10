using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapCoreSupportProcessModule
{
    public class ReportKraRoadMapKpiDto : BaseDto<KraRoadMapKpi, int>
    {
        public string? Sequence { get; set; }
        public string? KpiDescription { get; set; }
        public string? Target { get; set; }
        public string? BaseLine { get; set; }
        public List<string?>? PercentAccomplished { get; set; }
        public List<string?>? Targets { get; set; }

        public ReportKraRoadMapKpiDto()
        {
            PercentAccomplished = new List<string?>();
            Targets = new List<string?>();
        }

        public ReportKraRoadMapKpiDto(KraRoadMapKpi kpi)
        {
            Id = kpi.Id;
            Sequence = kpi.KraRoadmapKpiSequence?.SequenceCode;
            KpiDescription = kpi.KpiDescription;
            Target = kpi.Target;
            BaseLine = kpi.BaseLine;
            PercentAccomplished = new List<string?>();
            Targets = new List<string?>();
        }

        public override KraRoadMapKpi ToEntity()
        {
            return new KraRoadMapKpi
            {
                Id = Id,
                KpiDescription = KpiDescription,
                Target = Target,
                BaseLine = BaseLine
            };
        }
    }
}