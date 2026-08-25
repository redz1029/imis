using Base.Primitives;

namespace IMIS.Domain
{
    public class PerformanceValidationToolConclusion : Entity<long>
    {
        public long PerformanceValidationToolId { get; set; }
        public bool IsCompliant { get; set; }
        public bool IsImprovement { get; set; }
        public bool IsPartial { get; set; }
        public bool IsCritical { get; set; }
        public DateTime? PostingDate { get; set; }   
    }
}
