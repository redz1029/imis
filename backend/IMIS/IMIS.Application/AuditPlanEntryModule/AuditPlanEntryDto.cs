using Base.Primitives;
using IMIS.Application.AuditPlanPersonResponsibleModule;
using IMIS.Application.AuditPlanProcessModule;
using IMIS.Application.IsoAuditorModule;
using IMIS.Application.IsoAuditProcessModule;
using IMIS.Application.IsoStandardAuditPlanModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace IMIS.Application.AuditPlanEntryModule
{
    public class AuditPlanEntryDto : BaseDto<AuditPlanEntry, int>
    {
        public required int AuditPlanId { get; set; }

        public required int DayNumber { get; set; }

        public required DateTime Time { get; set; }

        public List<IsoAuditProcessDto>? IsoAuditProcesses { get; set; }

        public List<AuditPlanPersonResponsibleDto>? ResponsiblePersons { get; set; }

        public List<IsoAuditorDto>? IsoAuditors { get; set; }

        public List<IsoStandardAuditPlanDto>? IsoStandardAuditPlans { get; set; }

        public List<AuditPlanProcessDto>? AuditPlanProcesses { get; set; }

        public AuditPlanEntryDto() { }

        [SetsRequiredMembers]
        public AuditPlanEntryDto(AuditPlanEntry entity)
        {
            this.Id = entity.Id;
            this.AuditPlanId = entity.AuditPlanId;
            this.DayNumber = entity.DayNumber;
            this.Time = entity.Time;

            this.IsoAuditProcesses = entity.IsoAuditProcesses != null
                ? entity.IsoAuditProcesses.Select(x => new IsoAuditProcessDto(x)).ToList()
                : new List<IsoAuditProcessDto>();

            this.ResponsiblePersons = entity.ResponsiblePersons != null
                ? entity.ResponsiblePersons.Select(x => new AuditPlanPersonResponsibleDto(x)).ToList()
                : new List<AuditPlanPersonResponsibleDto>();

            this.IsoAuditors = entity.IsoAuditors != null
                ? entity.IsoAuditors.Select(x => new IsoAuditorDto(x)).ToList()
                : new List<IsoAuditorDto>();

            this.IsoStandardAuditPlans = entity.IsoStandardAuditPlans != null
                ? entity.IsoStandardAuditPlans.Select(x => new IsoStandardAuditPlanDto(x)).ToList()
                : new List<IsoStandardAuditPlanDto>();

            this.AuditPlanProcesses = entity.AuditPlanProcesses != null
                ? entity.AuditPlanProcesses.Select(x => new AuditPlanProcessDto(x)).ToList()
                : new List<AuditPlanProcessDto>();

            this.RowVersion = entity.RowVersion;
        }

        public override AuditPlanEntry ToEntity()
        {
            return new AuditPlanEntry
            {
                Id = this.Id,
                AuditPlanId = this.AuditPlanId,
                DayNumber = this.DayNumber,
                Time = this.Time,

                IsoAuditProcesses = this.IsoAuditProcesses?.Select(x => x.ToEntity()).ToList(),

                ResponsiblePersons = this.ResponsiblePersons?.Select(x => x.ToEntity()).ToList(),

                IsoAuditors = this.IsoAuditors?.Select(x => x.ToEntity()).ToList(),

                IsoStandardAuditPlans = this.IsoStandardAuditPlans?.Select(x => x.ToEntity()).ToList(),

                AuditPlanProcesses = this.AuditPlanProcesses?.Select(x => x.ToEntity()).ToList(),

                RowVersion = this.RowVersion
            };
        }
    }
}