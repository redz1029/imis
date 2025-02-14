using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Domain;

namespace IMIS.Application.AuditScheduleModule
{
    public class AuditScheduleDto : BaseDto<AuditSchedule, int>
    {
        public required string AuditTitle { get; set; }
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }
        public required bool IsActive { get; set; }
        public List<OfficeDto>? Offices { get; set; }
        public List<AuditScheduleDetailDto>? AuditSchduleDetails { get; set; }
        public override AuditSchedule ToEntity()
        {
            return new AuditSchedule() 
            { 
                Id = Id, 
                AuditTitle = AuditTitle, 
                StartDate = StartDate, 
                EndDate = EndDate, 
                IsActive = IsActive 
            };
        }
    }
}
