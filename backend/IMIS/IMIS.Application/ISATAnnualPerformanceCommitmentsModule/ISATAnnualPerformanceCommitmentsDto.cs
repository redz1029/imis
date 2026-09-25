using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.ISATAnnualPerformanceCommitmentsModule
{
    public class ISATAnnualPerformanceCommitmentsDto : BaseDto<ISATAnnualPerformanceCommitments, long>
    {
        public long ISATId { get; set; }
        public string? Deliverable { get; set; }
        public string? Target { get; set; }
        public string? TimeLine { get; set; }
        public string? Status { get; set; }
        public string? Accomplishment { get; set; }

        public ISATAnnualPerformanceCommitmentsDto()
        {
        }

        [SetsRequiredMembers]
        public ISATAnnualPerformanceCommitmentsDto(ISATAnnualPerformanceCommitments ISATAnnualPerformanceCommitments)
        {
            this.Id = ISATAnnualPerformanceCommitments.Id;
            this.ISATId = ISATAnnualPerformanceCommitments.ISATId;
            this.Deliverable = ISATAnnualPerformanceCommitments.Deliverable;
            this.Target = ISATAnnualPerformanceCommitments.Target;
            this.TimeLine = ISATAnnualPerformanceCommitments.TimeLine;
            this.Status = ISATAnnualPerformanceCommitments.Status;
            this.Accomplishment = ISATAnnualPerformanceCommitments.Accomplishment;
        }
        public override ISATAnnualPerformanceCommitments ToEntity()
        {
            return new ISATAnnualPerformanceCommitments()
            {
                Id = Id,
                ISATId = ISATId,
                Deliverable = Deliverable,
                Target = Target,
                TimeLine = TimeLine,
                Status = Status,
                Accomplishment = Accomplishment,
            };
        }
    }
}
