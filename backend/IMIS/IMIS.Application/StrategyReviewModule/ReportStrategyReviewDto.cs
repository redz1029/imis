using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.StrategyReviewDeliverableModule;
using IMIS.Domain;

namespace IMIS.Application.StrategyReviewModule
{
    public class ReportStrategyReviewDto : BaseDto<StrategyReview, long>
    {
        public int StrategyReviewPeriodId { get; set; }
        public string? Quarter { get; set; }

        public DateTime PostingDate { get; set; }
        public long KraRoadMapId { get; set; }
        public string? StrategicObjective { get; set; }
        public string? OfficeNames { get; set; }

        public List<StrategyReviewDeliverableKpiDto>? StrategyReviewDeliverableKpi { get; set; }
        public List<StrategyReviewDeliverableDto>? StrategyReviewDeliverable { get; set; }

        public string? Continue { get; set; }
        public string? Start { get; set; }
        public string? Stop { get; set; }

        public ReportStrategyReviewDto() { }

        [SetsRequiredMembers]
        public ReportStrategyReviewDto(StrategyReview strategyReview)
        {
            Id = strategyReview.Id;
            PostingDate = strategyReview.PostingDate;
            KraRoadMapId = strategyReview.KraRoadMapId;
            Continue = strategyReview.Continue;
            Start = strategyReview.Start;
            Stop = strategyReview.Stop;

            this.StrategyReviewPeriodId = strategyReview.StrategyReviewPeriodId;
            Quarter = strategyReview.StrategyReviewPeriod?.Quarter;

            StrategyReviewDeliverableKpi = strategyReview.StrategyReviewDeliverableKpi?
                .Select(x => new StrategyReviewDeliverableKpiDto(x))
                .ToList();

            StrategyReviewDeliverable = strategyReview.StrategyReviewDeliverable?
                .Select(x => new StrategyReviewDeliverableDto(x))
                .ToList();
        }

        public override StrategyReview ToEntity() => new()
        {
            Id = Id,
            PostingDate = PostingDate,
            KraRoadMapId = KraRoadMapId,
            Continue = Continue,
            Start = Start,
            Stop = Stop,

            StrategyReviewPeriodId = this.StrategyReviewPeriodId,

            StrategyReviewDeliverableKpi = StrategyReviewDeliverableKpi?
                .Select(x => x.ToEntity())
                .ToList(),

            StrategyReviewDeliverable = StrategyReviewDeliverable?
                .Select(x => x.ToEntity())
                .ToList()
        };
    }
}