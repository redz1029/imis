using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditSchduleDetails : Entity<int>
    {
        public AuditSchedule AuditSchedule { get; set; }
        public DateTime StartDateTime { get; set; }
        public DateTime EndDateTime { get; set; }

        public int TeamId { get; set; }
        public IEnumerable<Auditor> Auditors { get; set; }
    }
}
