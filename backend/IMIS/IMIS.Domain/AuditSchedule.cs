using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditSchedule : Entity<int>
    {
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }

        public required String AuditTitle { get; set; }
        public required bool IsActive { get; set; }
        public IEnumerable<AuditableOffices>? AuditableOffices { get; set; }
        public IEnumerable<AuditScheduleDetails>? AuditSchduleDetails { get; set; }
    }
}
