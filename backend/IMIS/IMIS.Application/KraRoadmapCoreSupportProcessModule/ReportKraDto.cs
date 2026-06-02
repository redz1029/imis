using Base.Primitives;
using IMIS.Application.KraRoadmapCoreSupportProcessModule;
using IMIS.Domain;

public class ReportKraDto : BaseDto<KeyResultArea, int>
{
    public string? Name { get; set; }
    public string? Remarks { get; set; }
    public string? StrategicObjective { get; set; }

    public List<ReportKraRoadMapKpiDto>? Kpis { get; set; }
    public List<int>? Years { get; set; }

    public List<ReportKraRowDto> BuildList(int kraStatus) 
    {
        var list = new List<ReportKraRowDto>();

        if (Kpis == null || Id != kraStatus)
            return list;

        foreach (var kpi in Kpis)
        {
            list.Add(new ReportKraRowDto
            {
                KraName = Name,
                StrategicObjective = StrategicObjective,
                KpiDescription = kpi.KpiDescription,
                Target = kpi.Target,
                BaseLine = kpi.BaseLine,

                PercentAccomplished1 = kpi.PercentAccomplished?.ElementAtOrDefault(0),
                PercentAccomplished2 = kpi.PercentAccomplished?.ElementAtOrDefault(1),
                PercentAccomplished3 = kpi.PercentAccomplished?.ElementAtOrDefault(2),
                PercentAccomplished4 = kpi.PercentAccomplished?.ElementAtOrDefault(3),
                PercentAccomplished5 = kpi.PercentAccomplished?.ElementAtOrDefault(4)
            });
        }

        return list;
    }

    public List<ReportKraRowDto> ServiceList => BuildList(KraStatus.Service);
    public List<ReportKraRowDto> ResearchList => BuildList(KraStatus.Research);
    public List<ReportKraRowDto> TrainingList => BuildList(KraStatus.Training);
    public List<ReportKraRowDto> LinkagesList => BuildList(KraStatus.Linkages);
    public List<ReportKraRowDto> InfrastructureList => BuildList(KraStatus.Infrastructure);
    public List<ReportKraRowDto> FinancialStewardshipList => BuildList(KraStatus.FinacialStewardship);
    public List<ReportKraRowDto> InformationCapitalList => BuildList(KraStatus.InformationCapital);
    public List<ReportKraRowDto> HumanResourceList => BuildList(KraStatus.HumanResource);
    public List<ReportKraRowDto> SafetyList => BuildList(KraStatus.Safety);

 
    public int? Year1 => Years?.ElementAtOrDefault(0);
    public int? Year2 => Years?.ElementAtOrDefault(1);
    public int? Year3 => Years?.ElementAtOrDefault(2);
    public int? Year4 => Years?.ElementAtOrDefault(3);
    public int? Year5 => Years?.ElementAtOrDefault(4);

  
    public ReportKraDto()
    {
        Kpis = new List<ReportKraRoadMapKpiDto>();
        Years = new List<int>();
    }

    public ReportKraDto(KeyResultArea kra) : this()
    {
        Id = kra.Id;
        Name = kra.Name;
        Remarks = kra.Remarks;
        StrategicObjective = kra.StrategicObjective;
    }


    public override KeyResultArea ToEntity()
    {
        return new KeyResultArea
        {
            Id = Id,
            Name = Name!,
            Remarks = Remarks!,
            StrategicObjective = StrategicObjective
        };
    }


    public class ReportKraRowDto
    {
        public string? KraName { get; set; }
        public string? StrategicObjective { get; set; }

        public string? KpiDescription { get; set; }
        public string? Target { get; set; }
        public string? BaseLine { get; set; }

        public decimal? PercentAccomplished1 { get; set; }
        public decimal? PercentAccomplished2 { get; set; }
        public decimal? PercentAccomplished3 { get; set; }
        public decimal? PercentAccomplished4 { get; set; }
        public decimal? PercentAccomplished5 { get; set; }
    }
}