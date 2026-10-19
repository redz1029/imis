using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditableOffices : Entity<int>
    {
        public required int AuditScheduleId { get; set; }
        public AuditSchedule? AuditSchedule { get; set; }
        public required int OfficeId { get; set; }
        public Office? Office { get; set; }
    }
}

