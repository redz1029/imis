using Base.Primitives;

namespace IMIS.Domain
{
    public class PerformanceValidationToolValidators : Entity<long>
    {
        public long PerformanceValidationToolId { get; set; }
        public int AuditorId { get; set; }
        public Auditor? Auditor { get; set; }
        public DateTime PostingDate { get; set; }
    }
}
