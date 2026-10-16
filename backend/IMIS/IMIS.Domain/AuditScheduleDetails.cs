using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditScheduleDetails : Entity<int>
    {
        public required int AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; }
        public required int AuditScheduleId { get; set; }
        public AuditSchedule? AuditSchedule { get; set; }
    }
}
