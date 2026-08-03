using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule
{
    public class ImpactStrategicGoalScoreCardPeriodDto : BaseDto<ImpactStrategicGoalScoreCardPeriod, int>
    {
        public DateOnly StartDate { get; set; }
        public DateOnly EndDate { get; set; }
        public string? Period { get; set; }
        public bool? IsActive { get; set; }

        public ImpactStrategicGoalScoreCardPeriodDto() { }

        [SetsRequiredMembers]
        public ImpactStrategicGoalScoreCardPeriodDto(ImpactStrategicGoalScoreCardPeriod impactStrategicGoalScoreCardPeriod)
        {
            this.Id = impactStrategicGoalScoreCardPeriod.Id;
            this.StartDate = impactStrategicGoalScoreCardPeriod.StartDate;
            this.EndDate = impactStrategicGoalScoreCardPeriod.EndDate;
            this.Period = impactStrategicGoalScoreCardPeriod.Period;     
            this.IsActive = impactStrategicGoalScoreCardPeriod.IsActive;
        }
        public override ImpactStrategicGoalScoreCardPeriod ToEntity()
        {
            return new ImpactStrategicGoalScoreCardPeriod() { Id = Id, StartDate = StartDate, EndDate = EndDate, Period = Period, IsActive = IsActive };
        }


    }
}
