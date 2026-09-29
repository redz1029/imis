using Base.Primitives;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.IQASignatoryModule;
using IMIS.Application.IsoAuditorModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text.Json.Serialization;

namespace IMIS.Application.AuditPlanModule
{
    public class AuditPlanDto : BaseDto<AuditPlan, int>
    {
        public required string PlanName { get; set; }
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }

        public int AuditProgrammeId { get; set; }

        [JsonIgnore]
        public AuditProgrammeDto? AuditProgramme { get; set; }

        public int? PreparerId { get; set; }
        public IsoAuditorDto? Preparer { get; set; }

        // Read-only, derived from the IQA signatory rows (DRAFT / PENDING /
        // APPROVED / DISAPPROVED). NEVER mapped in ToEntity() — the state only
        // changes through AuditPlanService.SubmitAsync / DecideAsync.
        public string? StatusCode { get; set; }
        public string? StatusName { get; set; }

        public DateTime CreatedDate { get; set; }
        public DateTime? LastModifiedDate { get; set; }

        public List<AuditPlanEntryDto> Entries { get; set; } = new();
        public List<AuditScheduleDto> AuditSchedules { get; set; } = new();

        // Live approval chain, in signing order.
        public List<IQASignatoryDto> Signatories { get; set; } = new();

        public AuditPlanDto() { }

        [SetsRequiredMembers]
        public AuditPlanDto(AuditPlan entity)
        {
            this.Id = entity.Id;
            this.PlanName = entity.PlanName;
            this.StartDate = entity.StartDate;
            this.EndDate = entity.EndDate;
            this.CreatedDate = entity.CreatedDate;
            this.LastModifiedDate = entity.LastModifiedDate;
            this.AuditProgrammeId = entity.AuditProgrammeId;

            // Callers must load IQASignatories (non-deleted) or this reads as Draft.
            var signatories = IQAApprovalWorkflow.Ordered(entity.IQASignatories);
            var stateCode = IQAApprovalWorkflow.DeriveStateCode(signatories);
            this.StatusCode = stateCode;
            this.StatusName = IQAApprovalWorkflow.StateName(stateCode);
            this.Signatories = signatories.Select(s => new IQASignatoryDto(s)).ToList();

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
                PlanName = this.PlanName,
                StartDate = this.StartDate,
                EndDate = this.EndDate,
                CreatedDate = this.CreatedDate,
                LastModifiedDate = this.LastModifiedDate,
                AuditProgrammeId = this.AuditProgrammeId,
                Preparer = this.Preparer?.ToEntity(),

                Entries = this.Entries?.Select(x => x.ToEntity()).ToList()
                                 ?? new List<AuditPlanEntry>(),
                AuditSchedules = this.AuditSchedules?.Select(x => x.ToEntity()).ToList()
                                 ?? new List<AuditSchedule>(),

                RowVersion = this.RowVersion
            };
        }
    }
}