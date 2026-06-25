using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolDeliverableFindingsModule
{
    public class PerformanceValidationToolDeliverableFindingsDto : BaseDto<PerformanceValidationToolDeliverableFindings, long>
    {
        public long PerformanceValidationToolId { get; set; }
        public long? PgsDeliverableId { get; set; }
        public string? DeliverableName { get; set; }
        public string? Findings { get; set; }
        public bool? IsNC { get; set; }
        public bool? IsOFI { get; set; }
        public DateTime? PostingDate { get; set; }
        public PerformanceValidationToolDeliverableFindingsDto()
        {
        }

        [SetsRequiredMembers]
        public PerformanceValidationToolDeliverableFindingsDto(PerformanceValidationToolDeliverableFindings performanceValidationToolDeliverableFindings)
        {
            this.Id = performanceValidationToolDeliverableFindings.Id;
            this.PerformanceValidationToolId = performanceValidationToolDeliverableFindings.PerformanceValidationToolId;
            this.PgsDeliverableId = performanceValidationToolDeliverableFindings.PgsDeliverableId;
            this.Findings = performanceValidationToolDeliverableFindings.Findings;
            this.IsNC = performanceValidationToolDeliverableFindings.IsNC;
            this.IsOFI = performanceValidationToolDeliverableFindings.IsOFI;
            this.PostingDate = performanceValidationToolDeliverableFindings.PostingDate;
        }
        public override PerformanceValidationToolDeliverableFindings ToEntity()
        {
            return new PerformanceValidationToolDeliverableFindings()
            {
                Id = Id,
                PerformanceValidationToolId = PerformanceValidationToolId,
                PgsDeliverableId = PgsDeliverableId,
                Findings = Findings,
                IsNC = IsNC,
                IsOFI = IsOFI,
                PostingDate = PostingDate,
            };
        }
    }
}

