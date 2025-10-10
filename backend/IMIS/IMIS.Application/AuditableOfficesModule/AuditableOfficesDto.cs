using System.Diagnostics.CodeAnalysis;
using IMIS.Domain;

namespace IMIS.Application.AuditableOfficesModule
{
    public class AuditableOfficesDto
    {
        public required int AuditScheduleId { get; set; }       
        public required int OfficeId { get; set; }

        public AuditableOfficesDto() { }
        [SetsRequiredMembers]
        public AuditableOfficesDto(AuditableOffices auditableOffices)
        {
            this.AuditScheduleId = auditableOffices.AuditScheduleId;
            this.OfficeId = auditableOffices.OfficeId;         
        }

        public AuditableOffices ToEntity()
        {
            return new AuditableOffices
            {                
                AuditScheduleId = AuditScheduleId,
                OfficeId = OfficeId,                   
            };
        }
    }
}
