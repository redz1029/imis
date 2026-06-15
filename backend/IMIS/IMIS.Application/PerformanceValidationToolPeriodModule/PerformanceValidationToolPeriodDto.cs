using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolPeriodModule
{
    public class PerformanceValidationToolPeriodDto : BaseDto<PerformanceValidationToolPeriod, int>
    {
        public DateOnly StartDate { get; set; }
        public DateOnly EndDate { get; set; }
        public string? Period { get; set; }

        public PerformanceValidationToolPeriodDto() { }

        [SetsRequiredMembers]
        public PerformanceValidationToolPeriodDto(PerformanceValidationToolPeriod strategyReviewPeriod)
        {
            this.Id = strategyReviewPeriod.Id;
            this.StartDate = strategyReviewPeriod.StartDate;
            this.EndDate = strategyReviewPeriod.EndDate;
            this.Period = strategyReviewPeriod.Period;
        }
        public override PerformanceValidationToolPeriod ToEntity()
        {
            return new PerformanceValidationToolPeriod() { Id = Id, StartDate = StartDate, EndDate = EndDate, Period = Period };
        }
    }
}
