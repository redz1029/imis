using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.StrategyReviewDeliverableModule;
using IMIS.Domain;

namespace IMIS.Application.StrategyReviewModule
{
    public class StrategyReviewDto : BaseDto<StrategyReview, long>
    {
     
        public int StrategyReviewPeriodId { get; set; }
        public string? StrategyReviewPeriod { get; set; }
        public DateTime PostingDate { get; set; }
        public long KraRoadMapId { get; set; }
        public string? StrategicObjective { get; set; }
        public string? OfficeNames { get; set; }
        public List<StrategyReviewDeliverableKpiDto>? StrategyReviewDeliverableKpi { get; set; }
        public List<StrategyReviewDeliverableDto>? StrategyReviewDeliverable { get; set; }
        public string? Continue { get; set; }
        public string? Start { get; set; }
        public string? Stop { get; set; }
        public  string? RoleId { get; set; }

        public StrategyReviewDto() { }

        [SetsRequiredMembers]
        public StrategyReviewDto(StrategyReview strategyReview)
        {
            this.Id = strategyReview.Id;
            this.StrategyReviewPeriodId = strategyReview.StrategyReviewPeriodId;
            StrategyReviewPeriod = strategyReview.StrategyReviewPeriod != null
            ? $"{strategyReview.StrategyReviewPeriod.StartDate:MMMM dd, yyyy} to {strategyReview.StrategyReviewPeriod.EndDate:MMMM dd, yyyy}"
            : null;
            this.PostingDate = strategyReview.PostingDate;
            this.KraRoadMapId = strategyReview.KraRoadMapId;
            this.Continue = strategyReview.Continue;
            this.Start = strategyReview.Start;
            this.Stop = strategyReview.Stop;
            this.StrategyReviewDeliverableKpi = strategyReview.StrategyReviewDeliverableKpi?
                .Select(x => new StrategyReviewDeliverableKpiDto(x)).ToList();
            this.StrategyReviewDeliverable = strategyReview.StrategyReviewDeliverable?
                .Select(x => new StrategyReviewDeliverableDto(x)).ToList();
            this.RoleId = strategyReview.RoleId!;
        }

        public override StrategyReview ToEntity() => new()
        {
            Id = this.Id,
            StrategyReviewPeriodId = this.StrategyReviewPeriodId,           
            PostingDate = this.PostingDate,
            KraRoadMapId = this.KraRoadMapId,
            Continue = this.Continue,
            Start = this.Start,
            Stop = this.Stop,
            StrategyReviewDeliverableKpi = this.StrategyReviewDeliverableKpi?
                .Select(x => x.ToEntity()).ToList(),
            StrategyReviewDeliverable = this.StrategyReviewDeliverable?
                .Select(x => x.ToEntity()).ToList(),
            RoleId = this.RoleId,
        };
    }
}
