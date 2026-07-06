using System;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Collections.Generic;
using System.Text.Json.Serialization; // CRITICAL for mapping names
using Base.Primitives;
using IMIS.Application.AuditPlanModule;
using IMIS.Domain;

namespace IMIS.Application.AuditProgrammeModule
{
    public class AuditProgrammeDto : BaseDto<AuditProgramme, int>
    {
        public int Year { get; set; }
        public required string For { get; set; }
        public required string From { get; set; }
        public required string Purpose { get; set; }
        public required string ScopeAndFreqAudit { get; set; }
        public required string InternalAuditSched { get; set; }
        public required string AuditPlanObjective { get; set; }
        public required string ScopeOfAudit { get; set; }

        public List<AuditProgrammeObjectiveDto> Objectives { get; set; } = new();

        // FIX FOR FASTREPORT: Exposes a single, flat string holding all row descriptions broken by newlines
        [JsonPropertyName("combinedObjectivesText")]
        public string CombinedObjectivesText { get; set; } = string.Empty;

        [JsonPropertyName("auditPlan")]
        public List<AuditPlanDto> AuditPlans { get; set; } = new();

        public AuditProgrammeDto() { }

        [SetsRequiredMembers]
        public AuditProgrammeDto(AuditProgramme entity)
        {
            Id = entity.Id;
            Year = entity.Year;
            For = entity.For;
            From = entity.From;
            Purpose = entity.Purpose;
            ScopeAndFreqAudit = entity.ScopeAndFreqAudit;
            InternalAuditSched = entity.InternalAuditSched;
            AuditPlanObjective = entity.AuditPlanObjective;
            ScopeOfAudit = entity.ScopeOfAudit;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            if (entity.Objectives != null && entity.Objectives.Any())
            {
                // 1. Maintain the native object array projection structure
                Objectives = entity.Objectives
                    .OrderBy(o => o.SortOrder)
                    .Select(o => new AuditProgrammeObjectiveDto(o))
                    .ToList();

                // 2. CONCATENATION FIX: Automatically combine descriptions with line breaks for FastReport text boxes
                CombinedObjectivesText = string.Join(Environment.NewLine, entity.Objectives
                    .OrderBy(o => o.SortOrder)
                    .Select(o => o.Description));
            }

            if (entity.AuditPlans != null)
            {
                AuditPlans = entity.AuditPlans
                    .Select(p => new AuditPlanDto(p))
                    .ToList();
            }
        }

        public override AuditProgramme ToEntity()
        {
            return new AuditProgramme
            {
                Id = Id,
                Year = Year,
                For = For,
                From = From,
                Purpose = Purpose,
                ScopeAndFreqAudit = ScopeAndFreqAudit,
                InternalAuditSched = InternalAuditSched,
                AuditPlanObjective = AuditPlanObjective,
                ScopeOfAudit = ScopeOfAudit,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion,

                Objectives = Objectives?.Select(o => o.ToEntity()).ToList() ?? new List<AuditProgrammeObjective>(),
                AuditPlans = AuditPlans?.Select(p => p.ToEntity()).ToList() ?? new List<AuditPlan>()
            };
        }
    }
}