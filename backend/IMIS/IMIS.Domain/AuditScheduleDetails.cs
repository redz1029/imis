using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditScheduleDetails : Entity<int>
    {
        public required int AuditScheduleId { get; set; }
        public AuditSchedule? AuditSchedule { get; set; }
        public DateTime StartDateTime { get; set; }
        public DateTime EndDateTime { get; set; }
        public required int TeamId { get; set; }
        public Team? Team { get; set; }
        public required int OfficeId { get; set; }
        public Office? Office { get; set; }
  

    }
}
