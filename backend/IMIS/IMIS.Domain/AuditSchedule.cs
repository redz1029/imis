using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditSchedule : Entity<int>
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public String AuditTitle { get; set; }
        public bool IsActive { get; set; }
    }
}
