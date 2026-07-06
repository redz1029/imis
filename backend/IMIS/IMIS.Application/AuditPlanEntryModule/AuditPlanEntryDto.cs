using Base.Primitives;
using IMIS.Application.AuditPlanModule;
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
using System.Text.Json.Serialization;

namespace IMIS.Application.AuditPlanEntryModule
{
    public class AuditPlanEntryDto : BaseDto<AuditPlanEntry, int>
    {
        [JsonPropertyName("auditPlanId")]
        public required int AuditPlanId { get; set; }

        // FIX: The crucial attribute to prevent the serializer from entering an infinite loop.
        // This completely hides the parent back-reference path from the JSON serializer engine and Swagger.
        [JsonIgnore]
        [JsonPropertyName("auditPlan")]
        public AuditPlanDto? AuditPlan { get; set; }

        [JsonPropertyName("dayNumber")]
        public required int DayNumber { get; set; }

        [JsonPropertyName("time")]
        public required DateTime Time { get; set; }

        // STABILIZATION: Ensured non-nullable lists initialized to empty instances to secure 
        // frontend payload rendering from missing reference null crashes.
        [JsonPropertyName("isoAuditProcesses")]
        public List<IsoAuditProcessDto> IsoAuditProcesses { get; set; } = new();

        [JsonPropertyName("responsiblePersons")]
        public List<AuditPlanPersonResponsibleDto> ResponsiblePersons { get; set; } = new();

        [JsonPropertyName("isoAuditors")]
        public List<IsoAuditorDto> IsoAuditors { get; set; } = new();

        [JsonPropertyName("isoStandardAuditPlans")]
        public List<IsoStandardAuditPlanDto> IsoStandardAuditPlans { get; set; } = new();

        [JsonPropertyName("auditPlanProcesses")]
        public List<AuditPlanProcessDto> AuditPlanProcesses { get; set; } = new();

        public AuditPlanEntryDto() { }

        [SetsRequiredMembers]
        public AuditPlanEntryDto(AuditPlanEntry entity)
        {
            this.Id = entity.Id;
            this.AuditPlanId = entity.AuditPlanId;
            this.DayNumber = entity.DayNumber;
            this.Time = entity.Time;

            // FIX: Never initialize the full parent AuditPlanDto graph node inside a child constructor.
            // Leaving this null breaks the infinite recursion execution ring.
            this.AuditPlan = null;

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
                AuditPlan = null, // Safely broken reference path

                DayNumber = this.DayNumber,
                Time = this.Time,

                IsoAuditProcesses = this.IsoAuditProcesses?.Select(x => x.ToEntity()).ToList() ?? new List<IsoAuditProcess>(),
                ResponsiblePersons = this.ResponsiblePersons?.Select(x => x.ToEntity()).ToList() ?? new List<AuditPlanPersonResponsible>(),
                IsoAuditors = this.IsoAuditors?.Select(x => x.ToEntity()).ToList() ?? new List<IsoAuditor>(),
                IsoStandardAuditPlans = this.IsoStandardAuditPlans?.Select(x => x.ToEntity()).ToList() ?? new List<IsoStandardAuditPlan>(),
                AuditPlanProcesses = this.AuditPlanProcesses?.Select(x => x.ToEntity()).ToList() ?? new List<AuditPlanProcess>(),

                RowVersion = this.RowVersion
            };
        }
    }
}