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
        public override AuditScheduleDetails ToEntity()
        {
            return new AuditScheduleDetails() 
            { 
                Id = Id, 
                AuditScheduleId = AuditScheduleId, 
                TeamId = TeamId, 
                StartDateTime = StartDateTime, 
                EndDateTime = EndDateTime,
                OfficeId = OfficeId
            };
        }
    }
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          