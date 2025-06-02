using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsPeriodModule
{
    public class PgsPeriodDto : BaseDto<PgsPeriod, int>
    {        
        public DateOnly StartDate { get; set; }
        public DateOnly EndDate { get; set; }
        public string? Remarks { get; set; }

        public PgsPeriodDto() { }

        [SetsRequiredMembers]
        public PgsPeriodDto(PgsPeriod pgsPeriod)
        {
            this.Id = pgsPeriod.Id;
            this.StartDate = pgsPeriod.StartDate;
            this.EndDate = pgsPeriod.EndDate;
            this.Remarks = pgsPeriod.Remarks;
        }
        public override PgsPeriod ToEntity()
        {
            return new PgsPeriod() { Id = Id, StartDate = StartDate, EndDate = EndDate, Remarks = Remarks };
        }      
    }
}
