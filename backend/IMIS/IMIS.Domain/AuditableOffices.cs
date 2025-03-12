namespace IMIS.Domain
{
    public class AuditableOffices
    {
        public required int AuditScheduleId { get; set; }
        public required AuditSchedule AuditSchedule { get; set; }
        public required int OfficeId { get; set; }
        public required Office Office { get; set; }
    }
}

