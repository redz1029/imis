using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsPeriodModule
{
    public class PgsPeriodDto : BaseDto<PgsPeriod, int>
    {        
        public required DateOnly StartDate { get; set; }
        public required DateOnly EndDate { get; set; }
        public override PgsPeriod ToEntity()
        {
            return new PgsPeriod() { Id = Id, StartDate = StartDate, EndDate = EndDate };
        }      
    }
}
