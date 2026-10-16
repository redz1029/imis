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
            this.Id = auditSchedule.Id;
            this.AuditTitle = auditSchedule.AuditTitle;
            this.StartDate = auditSchedule.StartDate;
            this.EndDate = auditSchedule.EndDate;
            this.IsActive = auditSchedule.IsActive;
          
            this.AuditableOffices = auditSchedule.AuditableOffices != null
                ? auditSchedule.AuditableOffices
                    .Select(o => new AuditableOfficesDto(o))
                    .ToList()
                : new List<AuditableOfficesDto>();

            this.AuditSchduleDetails = auditSchedule.AuditSchduleDetails != null
            ? auditSchedule.AuditSchduleDetails
                .Select(d => new AuditScheduleDetailDto(d))
                .ToList()
            : new List<AuditScheduleDetailDto>();

            this.RowVersion = auditSchedule.RowVersion;


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
                RowVersion = RowVersion,
            };
        }
    }
}
