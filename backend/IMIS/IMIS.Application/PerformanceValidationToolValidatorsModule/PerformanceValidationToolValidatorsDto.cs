using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolValidatorsModule
{
    public class PerformanceValidationToolValidatorsDto : BaseDto<PerformanceValidationToolValidators, long>
    {
        public long PerformanceValidationToolId { get; set; }
        public int AuditorId { get; set; }
        public string? AuditorName { get; set; }
        public DateTime PostingDate { get; set; }     
        public PerformanceValidationToolValidatorsDto()
        {
        }
        [SetsRequiredMembers]
        public PerformanceValidationToolValidatorsDto(PerformanceValidationToolValidators performanceValidationToolValidators)
        {
            this.Id = performanceValidationToolValidators.Id;
            this.PerformanceValidationToolId = performanceValidationToolValidators.PerformanceValidationToolId;
            this.AuditorId = performanceValidationToolValidators.AuditorId;
            this.PostingDate = performanceValidationToolValidators.PostingDate;
        }
        public override PerformanceValidationToolValidators ToEntity()
        {
            return new PerformanceValidationToolValidators() {
                Id = Id, PerformanceValidationToolId = PerformanceValidationToolId,
                AuditorId = AuditorId,
                PostingDate = PostingDate
            };
        }
    }
}
