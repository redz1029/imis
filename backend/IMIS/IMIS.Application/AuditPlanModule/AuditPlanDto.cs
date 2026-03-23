using Base.Primitives;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Application.AuditPlanApprovalModule;
using IMIS.Application.IsoAuditorModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace IMIS.Application.AuditPlanModule
{
    public class AuditPlanDto : BaseDto<AuditPlan, int>
    {
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }

        public IsoAuditorDto? Preparer { get; set; }

        public required string PlanStatus { get; set; }

        public DateTime CreatedDate { get; set; }
        public DateTime? LastModifiedDate { get; set; }

        // Navigation DTOs
        public List<AuditPlanEntryDto>? Entries { get; set; }
        public List<AuditPlanApprovalDto>? Approvals { get; set; }

        public AuditPlanDto() { }

        [SetsRequiredMembers]
        public AuditPlanDto(AuditPlan entity)
        {
            this.Id = entity.Id;
            this.StartDate = entity.StartDate;
            this.EndDate = entity.EndDate;
            this.PlanStatus = entity.PlanStatus;
            this.CreatedDate = entity.CreatedDate;
            this.LastModifiedDate = entity.LastModifiedDate;

            this.Preparer = entity.Preparer != null
                ? new IsoAuditorDto(entity.Preparer)
                : null;

            this.Entries = entity.Entries != null
                ? entity.Entries.Select(x => new AuditPlanEntryDto(x)).ToList()
                : new List<AuditPlanEntryDto>();

            this.Approvals = entity.Approvals != null
                ? entity.Approvals.Select(x => new AuditPlanApprovalDto(x)).ToList()
                : new List<AuditPlanApprovalDto>();

            this.RowVersion = entity.RowVersion;
        }

        public override AuditPlan ToEntity()
        {
            return new AuditPlan
            {
                Id = this.Id,
                StartDate = this.StartDate,
                EndDate = this.EndDate,
                PlanStatus = this.PlanStatus,
                CreatedDate = this.CreatedDate,
                LastModifiedDate = this.LastModifiedDate,

                Preparer = this.Preparer?.ToEntity(),

                Entries = this.Entries?.Select(x => x.ToEntity()).ToList(),
                Approvals = this.Approvals?.Select(x => x.ToEntity()).ToList(),

                RowVersion = this.RowVersion
            };
        }
    }
}