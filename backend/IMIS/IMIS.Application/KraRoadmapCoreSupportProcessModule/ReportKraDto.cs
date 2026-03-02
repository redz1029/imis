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

    public string? KraName1 => Name;  
    public string? StrategicObjective1 => Kpis?.FirstOrDefault()?.KpiDescription != null ? StrategicObjective : null;
    public string? KpiDescription1 => Kpis?.ElementAtOrDefault(0)?.KpiDescription;
    public string? Target1 => Kpis?.ElementAtOrDefault(0)?.Target;
    public string? BaseLine1 => Kpis?.ElementAtOrDefault(0)?.BaseLine;

    public decimal? PercentAccomplished1 => Kpis?.ElementAtOrDefault(0)?.PercentAccomplished?.ElementAtOrDefault(0);
    public decimal? PercentAccomplished2 => Kpis?.ElementAtOrDefault(0)?.PercentAccomplished?.ElementAtOrDefault(1);
    public decimal? PercentAccomplished3 => Kpis?.ElementAtOrDefault(0)?.PercentAccomplished?.ElementAtOrDefault(2);
    public decimal? PercentAccomplished4 => Kpis?.ElementAtOrDefault(0)?.PercentAccomplished?.ElementAtOrDefault(3);
    public decimal? PercentAccomplished5 => Kpis?.ElementAtOrDefault(0)?.PercentAccomplished?.ElementAtOrDefault(4);

    public string? KraName2 => Name;  
    public string? KpiDescription2 => Kpis?.ElementAtOrDefault(1)?.KpiDescription;
    public string? Target2 => Kpis?.ElementAtOrDefault(1)?.Target;
    public string? BaseLine2 => Kpis?.ElementAtOrDefault(1)?.BaseLine;

    public decimal? PercentAccomplished6 => Kpis?.ElementAtOrDefault(1)?.PercentAccomplished?.ElementAtOrDefault(0);
    public decimal? PercentAccomplished7 => Kpis?.ElementAtOrDefault(1)?.PercentAccomplished?.ElementAtOrDefault(1);
    public decimal? PercentAccomplished8 => Kpis?.ElementAtOrDefault(1)?.PercentAccomplished?.ElementAtOrDefault(2);
    public decimal? PercentAccomplished9 => Kpis?.ElementAtOrDefault(1)?.PercentAccomplished?.ElementAtOrDefault(3);
    public decimal? PercentAccomplished10 => Kpis?.ElementAtOrDefault(1)?.PercentAccomplished?.ElementAtOrDefault(4);

    // Flattened Years
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
}

