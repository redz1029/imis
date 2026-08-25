using Base.Primitives;
using IMIS.Domain;
using System;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.AuditScheduleModule
{
    public class AuditScheduleDto : BaseDto<AuditSchedule, int>
    {
        public required string Purpose { get; set; }
        public required AuditorTeams? AuditorTeams { get; set; }
        public required string AuditTitle { get; set; }
        public required bool IsActive { get; set; }

        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public int AuditPlanId { get; set; }

        public AuditScheduleDto() { }

        [SetsRequiredMembers]
        public AuditScheduleDto(AuditSchedule entity)
        {
            this.Id = entity.Id;
            this.Purpose = entity.Purpose;
            this.AuditorTeams = entity.AuditorTeams;
            this.AuditTitle = entity.AuditTitle;
            this.IsActive = entity.IsActive;
            this.StartDate = entity.StartDate;
            this.EndDate = entity.EndDate;
            this.AuditPlanId = entity.AuditPlanId;
            this.RowVersion = entity.RowVersion;
        }

        public override AuditSchedule ToEntity()
        {
            return new AuditSchedule
            {
                Id = this.Id,
                Purpose = this.Purpose,
                AuditorTeams = this.AuditorTeams,
                AuditTitle = this.AuditTitle,
                IsActive = this.IsActive,
                StartDate = this.StartDate,
                EndDate = this.EndDate,
                AuditPlanId = this.AuditPlanId,
                RowVersion = this.RowVersion
            };
        }
    }
}