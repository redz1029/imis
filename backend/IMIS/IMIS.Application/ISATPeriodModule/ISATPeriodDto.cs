using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.IndividualStrategicAlignmentTreePeriodModule
{
    public class ISATPeriodDto :  BaseDto<ISATPeriod, int>
    {
        public required DateOnly StartDate { get; set; }
        public required DateOnly EndDate { get; set; }
        public string? Remarks { get; set; }
        public bool? IsActive { get; set; }

        public ISATPeriodDto() { }

        [SetsRequiredMembers]
        public ISATPeriodDto(ISATPeriod pgsPeriod)
        {
            this.Id = pgsPeriod.Id;
            this.StartDate = pgsPeriod.StartDate;
            this.EndDate = pgsPeriod.EndDate;
            this.Remarks = pgsPeriod.Remarks;
            this.IsDeleted = pgsPeriod.IsDeleted;
            this.RowVersion = pgsPeriod.RowVersion;
            this.IsActive = pgsPeriod.IsActive;
        }
        public override ISATPeriod ToEntity()
        {
            return new ISATPeriod() { Id = Id, StartDate = StartDate, EndDate = EndDate, Remarks = Remarks, IsActive = IsActive };
        }
    }
}
