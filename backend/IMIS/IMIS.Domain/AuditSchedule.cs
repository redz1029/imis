using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditSchedule : Entity<int>
    {
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }

        public required String AuditTitle { get; set; }
        public required bool IsActive { get; set; }
        public ICollection<AuditableOffices>? AuditableOffices { get; set; }
        public ICollection<AuditScheduleDetails>? AuditSchduleDetails { get; set; }
    }
}
