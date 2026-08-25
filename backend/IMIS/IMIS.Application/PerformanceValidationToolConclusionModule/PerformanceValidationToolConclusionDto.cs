
using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolConclusionModule
{
    public class PerformanceValidationToolConclusionDto : BaseDto<PerformanceValidationToolConclusion, long>
    {
        public long PerformanceValidationToolId { get; set; }
        public bool IsCompliant { get; set; }
        public bool IsImprovement { get; set; }
        public bool IsPartial { get; set; }
        public bool IsCritical { get; set; }
        public DateTime? PostingDate { get; set; }
        public PerformanceValidationToolConclusionDto()
        {
        }

        [SetsRequiredMembers]
        public PerformanceValidationToolConclusionDto(PerformanceValidationToolConclusion performanceValidationToolConclusion)
        {
            this.Id = performanceValidationToolConclusion.Id;
            this.PerformanceValidationToolId = performanceValidationToolConclusion.PerformanceValidationToolId;
            this.IsCompliant = performanceValidationToolConclusion.IsCompliant;
            this.IsImprovement = performanceValidationToolConclusion.IsImprovement;
            this.IsPartial = performanceValidationToolConclusion.IsPartial;
            this.IsCritical = performanceValidationToolConclusion.IsCritical;
            this.PostingDate = performanceValidationToolConclusion.PostingDate;
        }
        public override PerformanceValidationToolConclusion ToEntity()
        {
            return new PerformanceValidationToolConclusion()
            {
                Id = Id,
                PerformanceValidationToolId = PerformanceValidationToolId,
                IsCompliant = IsCompliant,
                IsImprovement = IsImprovement,
                IsPartial = IsPartial,
                IsCritical = IsCritical,
                PostingDate = PostingDate,
            };
        }
    }
}
