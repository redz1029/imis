using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditScheduleModule
{
    public class AuditScheduleDetailDto : BaseDto<AuditScheduleDetails, int>
    {    
        public required int AuditScheduleId { get; set; }
        public DateTime StartDateTime { get; set; }
        public DateTime EndDateTime { get; set; }
        public required int TeamId { get; set; }
        public string? TeamName { get; set; }
        public required int OfficeId { get; set; }
        public string? OfficeName { get; set; }

        public AuditScheduleDetailDto() { }
        [SetsRequiredMembers]
        public AuditScheduleDetailDto(AuditScheduleDetails auditableOffices)
        {
            this.Id = auditableOffices.Id;
            this.AuditScheduleId = auditableOffices.AuditScheduleId;
            this.TeamId = auditableOffices.TeamId;
            this.StartDateTime = auditableOffices.StartDateTime;
            this.EndDateTime = auditableOffices.EndDateTime;
            this.OfficeId = auditableOffices.OfficeId;
            this.RowVersion = auditableOffices.RowVersion;
        }
        public override AuditScheduleDetails ToEntity()
        {
            return new AuditScheduleDetails() 
            { 
                Id = Id, 
                AuditScheduleId = AuditScheduleId, 
                TeamId = TeamId, 
                StartDateTime = StartDateTime, 
                EndDateTime = EndDateTime,
                OfficeId = OfficeId,
                RowVersion = RowVersion,
            };
        }
    }
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          