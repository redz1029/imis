using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.StrategyReviewPeriodModule
{
    public class StrategyReviewPeriodDto : BaseDto<StrategyReviewPeriod, int>
    {
        public DateOnly StartDate { get; set; }
        public DateOnly EndDate { get; set; }
        public string? Quarter { get; set; }

        public StrategyReviewPeriodDto() { }

        [SetsRequiredMembers]
        public StrategyReviewPeriodDto(StrategyReviewPeriod strategyReviewPeriod)
        {
            this.Id = strategyReviewPeriod.Id;
            this.StartDate = strategyReviewPeriod.StartDate;
            this.EndDate = strategyReviewPeriod.EndDate;
            this.Quarter = strategyReviewPeriod.Quarter;       
        }
        public override StrategyReviewPeriod ToEntity()
        {
            return new StrategyReviewPeriod() { Id = Id, StartDate = StartDate, EndDate = EndDate, Quarter = Quarter };
        }
    }
}
