using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapPeriodModule
{
    public class KraRoadMapPeriodDto : BaseDto<KraRoadMapPeriod, int>
    {
        public DateOnly StartYear { get; set; }
        public DateOnly EndYear { get; set; }
      
        public KraRoadMapPeriodDto() { }

        [SetsRequiredMembers]
        public KraRoadMapPeriodDto(KraRoadMapPeriod kraRoadMapPeriod)
        {
            this.Id = kraRoadMapPeriod.Id;
            this.StartYear = kraRoadMapPeriod.StartYear;
            this.EndYear = kraRoadMapPeriod.EndYear;         
        }
        public override KraRoadMapPeriod ToEntity()
        {
            return new KraRoadMapPeriod() { Id = Id, StartYear = StartYear, EndYear = EndYear};
        }
    }
}
