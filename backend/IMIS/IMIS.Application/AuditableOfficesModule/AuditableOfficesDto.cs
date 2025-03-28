using IMIS.Domain;

namespace IMIS.Application.AuditableOfficesModule
{
    public class AuditableOfficesDto
    {
        public required int AuditScheduleId { get; set; }
        //public AuditSchedule? AuditSchedule { get; set; }
        public required int OfficeId { get; set; }
        //public Office? Office { get; set; }

    }
}
