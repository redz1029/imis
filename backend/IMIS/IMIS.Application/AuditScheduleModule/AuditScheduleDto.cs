using Base.Primitives;
using IMIS.Application.AuditableOfficesModule;
using IMIS.Application.AuditorTeamsModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace IMIS.Application.AuditScheduleModule
{
    public class AuditScheduleDto : BaseDto<AuditSchedule, int>
    {
        public required string Purpose { get; set; }
        public required string AuditTitle { get; set; }
        public required bool IsActive { get; set; }

        // Navigation DTOs
        public AuditorTeamsDto? AuditorTeams { get; set; }
        public List<AuditableOfficesDto>? AuditableOffices { get; set; }
        public List<AuditScheduleDetailsDto>? AuditScheduleDetails { get; set; }

        public AuditScheduleDto() { }

        [SetsRequiredMembers]
        public AuditScheduleDto(AuditSchedule entity)
        {
            this.Id = entity.Id;
            this.Purpose = entity.Purpose;
            this.AuditTitle = entity.AuditTitle;
            this.IsActive = entity.IsActive;

            this.AuditorTeams = entity.AuditorTeams != null
                ? new AuditorTeamsDto(entity.AuditorTeams)
                : null;

            this.AuditableOffices = entity.AuditableOffices != null
                ? entity.AuditableOffices.Select(x => new AuditableOfficesDto(x)).ToList()
                : new List<AuditableOfficesDto>();

            this.AuditScheduleDetails = entity.AuditSchduleDetails != null
                ? entity.AuditSchduleDetails.Select(x => new AuditScheduleDetailsDto(x)).ToList()
                : new List<AuditScheduleDetailsDto>();

            this.RowVersion = entity.RowVersion;
        }

        public override AuditSchedule ToEntity()
        {
            return new AuditSchedule
            {
                Id = this.Id,
                Purpose = this.Purpose,
                AuditTitle = this.AuditTitle,
                IsActive = this.IsActive,

                AuditorTeams = this.AuditorTeams?.ToEntity(),

                AuditableOffices = this.AuditableOffices?.Select(x => x.ToEntity()).ToList(),
                AuditSchduleDetails = this.AuditScheduleDetails?.Select(x => x.ToEntity()).ToList(),

                RowVersion = this.RowVersion
            };
        }
    }
}