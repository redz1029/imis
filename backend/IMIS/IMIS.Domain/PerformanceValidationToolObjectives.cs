using Base.Primitives;

namespace IMIS.Domain
{
    public class PerformanceValidationToolObjectives : Entity<long>
    {
        public long PerformanceValidationToolId { get; set; }
        public bool? IsAssessmentCompliant { get; set; }
        public bool? IsImplementationVerified { get; set; }
        public bool? IsDeliverableProgressMonitored { get; set; }
        public bool? HasOpportunitiesForImprovement { get; set; }
        public bool? IsValidated { get; set; }
        public DateTime? PostingDate { get; set; }

    }
}
