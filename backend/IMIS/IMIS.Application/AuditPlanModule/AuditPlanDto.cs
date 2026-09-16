using Base.Primitives;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Application.AuditPlanApprovalModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.IsoAuditorModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text.Json.Serialization;
using IMIS.Application.AuditProgrammeModule;

namespace IMIS.Application.AuditPlanModule
{
    public class AuditPlanDto : BaseDto<AuditPlan, int>
    {
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }

        public int AuditProgrammeId { get; set; }

        [JsonIgnore]
        public AuditProgrammeDto? AuditProgramme { get; set; }

        public int? PreparerId { get; set; }
        public IsoAuditorDto? Preparer { get; set; }

        // REMOVED: string PlanStatus — replaced with AuditStatusId FK pattern.
        // Status transitions go through ChangeStatusAsync only, never through
        // a general save. AuditStatusId is intentionally NOT mapped in ToEntity()
        // for the same reason as AuditProgrammeDto — prevents silent status revert
        // on every ordinary edit.
        public int AuditStatusId { get; set; }
        public string? StatusCode { get; set; }
        public string? StatusName { get; set; }

        public DateTime CreatedDate { get; set; }
        public DateTime? LastModifiedDate { get; set; }

        public List<AuditPlanEntryDto> Entries { get; set; } = new();
        public List<AuditPlanApprovalDto> Approvals { get; set; } = new();
        public List<AuditScheduleDto> AuditSchedules { get; set; } = new();

        public AuditPlanDto() { }

        [SetsRequiredMembers]
        public AuditPlanDto(AuditPlan entity)
        {
            this.Id = entity.Id;
            this.StartDate = entity.StartDate;
            this.EndDate = entity.EndDate;
            this.AuditStatusId = entity.AuditStatusId;
            this.StatusCode = entity.AuditStatus?.Code;
            this.StatusName = entity.AuditStatus?.Name;
            this.CreatedDate = entity.CreatedDate;
            this.LastModifiedDate = entity.LastModifiedDate;
            this.AuditProgrammeId = entity.AuditProgrammeId;

            if (entity.Preparer != null)
            {
                this.Preparer = new IsoAuditorDto(entity.Preparer);
                this.PreparerId = entity.Preparer.Id;
            }
            else
            {
                this.Preparer = null;
                this.PreparerId = null;
            }

            this.Entries = entity.Entries != null
                ? entity.Entries.Select(x => new AuditPlanEntryDto(x)).ToList()
                : new List<AuditPlanEntryDto>();

            this.Approvals = entity.Approvals != null
                ? entity.Approvals.Select(x => new AuditPlanApprovalDto(x)).ToList()
                : new List<AuditPlanApprovalDto>();

            this.AuditSchedules = entity.AuditSchedules != null
                ? entity.AuditSchedules.Select(x => new AuditScheduleDto(x)).ToList()
                : new List<AuditScheduleDto>();

            this.RowVersion = entity.RowVersion;
        }

        public override AuditPlan ToEntity()
        {
            return new AuditPlan
            {
                Id = this.Id,
                StartDate = this.StartDate,
                EndDate = this.EndDate,
                CreatedDate = this.CreatedDate,
                LastModifiedDate = this.LastModifiedDate,
                AuditProgrammeId = this.AuditProgrammeId,
                Preparer = this.Preparer?.ToEntity(),

                // AuditStatusId intentionally NOT mapped here — same rule as
                // AuditProgrammeDto. New entities keep the domain Draft default;
                // SaveOrUpdateAsync explicitly preserves the existing value on
                // updates. Only ChangeStatusAsync may move the status forward.

                Entries = this.Entries?.Select(x => x.ToEntity()).ToList()
                                 ?? new List<AuditPlanEntry>(),
                Approvals = this.Approvals?.Select(x => x.ToEntity()).ToList()
                                 ?? new List<AuditPlanApproval>(),
                AuditSchedules = this.AuditSchedules?.Select(x => x.ToEntity()).ToList()
                                 ?? new List<AuditSchedule>(),

                RowVersion = this.RowVersion
            };
        }
    }
}
