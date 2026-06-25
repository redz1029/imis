using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolObjectivesModule
{
    public class PerformanceValidationToolObjectivesDto : BaseDto<PerformanceValidationToolObjectives, long>
    {
        public long PerformanceValidationToolId { get; set; }
        public bool? IsAssessmentCompliant { get; set; }
        public bool? IsImplementationVerified { get; set; }
        public bool? IsDeliverableProgressMonitored { get; set; }
        public bool? HasOpportunitiesForImprovement { get; set; }
        public bool? IsValidated { get; set; }
        public DateTime? PostingDate { get; set; }
        public PerformanceValidationToolObjectivesDto()
        {
        }
        [SetsRequiredMembers]
        public PerformanceValidationToolObjectivesDto(PerformanceValidationToolObjectives performanceValidationToolObjectives)
        {
            this.Id = performanceValidationToolObjectives.Id;
            this.PerformanceValidationToolId = performanceValidationToolObjectives.PerformanceValidationToolId;
            this.IsAssessmentCompliant = performanceValidationToolObjectives.IsAssessmentCompliant;
            this.IsImplementationVerified = performanceValidationToolObjectives.IsImplementationVerified;
            this.IsDeliverableProgressMonitored = performanceValidationToolObjectives.IsDeliverableProgressMonitored;
            this.HasOpportunitiesForImprovement = performanceValidationToolObjectives.HasOpportunitiesForImprovement;
            this.IsValidated = performanceValidationToolObjectives.IsValidated;
            this.PostingDate = performanceValidationToolObjectives.PostingDate;
        }
        public override PerformanceValidationToolObjectives ToEntity()
        {
            return new PerformanceValidationToolObjectives()
            {
                Id = Id,
                PerformanceValidationToolId = PerformanceValidationToolId,
                IsAssessmentCompliant = IsAssessmentCompliant,
                IsImplementationVerified = IsImplementationVerified,
                IsDeliverableProgressMonitored = IsDeliverableProgressMonitored,
                HasOpportunitiesForImprovement = HasOpportunitiesForImprovement,
                IsValidated = IsValidated,
                PostingDate = PostingDate,
            };
        }
    }
}
