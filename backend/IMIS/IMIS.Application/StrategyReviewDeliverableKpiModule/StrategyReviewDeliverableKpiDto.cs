using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Domain;

public class StrategyReviewDeliverableKpiDto : BaseDto<StrategyReviewDeliverableKpi, long>
{
    public long StrategyReviewId { get; set; }
    public long KpiId { get; set; }
    public string? ActualDate { get; set; }
    public required PgsStatus Status { get; set; }
    public KraRoadMapKpiDto? KpiDetails { get; set; }
    public StrategyReviewDeliverableKpiDto() { }
    [SetsRequiredMembers]
    public StrategyReviewDeliverableKpiDto(StrategyReviewDeliverableKpi entity)
    {
        Id = entity.Id;
        StrategyReviewId = entity.StrategyReviewId;
        KpiId = entity.KraRoadmapid; 
        ActualDate = entity.ActualDate;
        Status = entity.Status;
        KpiDetails = null;

    }

    public override StrategyReviewDeliverableKpi ToEntity()
    {
        return new StrategyReviewDeliverableKpi()
        {
            Id = Id,
            StrategyReviewId = StrategyReviewId,
            KraRoadmapid = KpiId, 
            ActualDate = ActualDate,
            Status = Status,
        };
    }
}