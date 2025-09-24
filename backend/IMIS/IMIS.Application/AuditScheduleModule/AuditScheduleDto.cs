using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.AuditableOfficesModule;
using IMIS.Domain;

namespace IMIS.Application.AuditScheduleModule
{
    public class AuditScheduleDto : BaseDto<AuditSchedule, int>
    {
        public required string AuditTitle { get; set; }
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }
        public required bool IsActive { get; set; }      
        public List<AuditableOfficesDto>? AuditableOffices { get; set; }
        public List<AuditScheduleDetailDto>? AuditSchduleDetails { get; set; }
        public AuditScheduleDto() { }   
        [SetsRequiredMembers]
        public AuditScheduleDto(AuditSchedule auditSchedule)
        {
            
            Id = auditSchedule.Id;
            AuditTitle = auditSchedule.AuditTitle;
            StartDate = auditSchedule.StartDate;
            EndDate = auditSchedule.EndDate;
            IsActive = auditSchedule.IsActive;
        }
        public override AuditSchedule ToEntity()
        {
            return new AuditSchedule() 
            { 
                Id = Id, 
                AuditTitle = AuditTitle, 
                StartDate = StartDate, 
                EndDate = EndDate, 
                IsActive = IsActive,                                   
                AuditableOffices = AuditableOffices?.Select(d => d.ToEntity()).ToList(),
                AuditSchduleDetails = AuditSchduleDetails?.Select(d => d.ToEntity()).ToList(),
            };
        }
    }
}
