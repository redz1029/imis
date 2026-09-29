using Base.Primitives;
using IMIS.Domain;
using System;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.AuditScheduleModule
{
    public class AuditScheduleDto : BaseDto<AuditSchedule, int>
    {
        public required string Purpose { get; set; }

        // FIX: was AuditorTeams (a single team-member pairing).
        public int? TeamId { get; set; }

        public required string Activity { get; set; }
        public required bool IsActive { get; set; }

        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public int AuditPlanId { get; set; }

        // FIX: AuditSchedule.AuditPlanEntryId is required on the entity —
        // ToEntity() must set it or the object initializer fails.
        public required int AuditPlanEntryId { get; set; }

        public AuditScheduleDto() { }

        [SetsRequiredMembers]
        public AuditScheduleDto(AuditSchedule entity)
        {
            this.Id = entity.Id;
            this.Purpose = entity.Purpose;
            this.TeamId = entity.TeamId;
            this.Activity = entity.Activity;
            this.IsActive = entity.IsActive;
            this.StartDate = entity.StartDate;
            this.EndDate = entity.EndDate;
            this.AuditPlanId = entity.AuditPlanId;
            this.AuditPlanEntryId = entity.AuditPlanEntryId;
            this.RowVersion = entity.RowVersion;
        }

        public override AuditSchedule ToEntity()
        {
            return new AuditSchedule
            {
                Id = this.Id,
                Purpose = this.Purpose,
                TeamId = this.TeamId,
                Activity = this.Activity,
                IsActive = this.IsActive,
                StartDate = this.StartDate,
                EndDate = this.EndDate,
                AuditPlanId = this.AuditPlanId,
                AuditPlanEntryId = this.AuditPlanEntryId,
                RowVersion = this.RowVersion
            };
        }
    }
}