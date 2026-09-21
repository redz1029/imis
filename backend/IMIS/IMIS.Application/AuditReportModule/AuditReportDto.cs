using System;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;
using IMIS.Application.AuditScopeModule;
using IMIS.Application.AuditComFindingsModule;
using IMIS.Application.AuditSummaryFindingsModule;

namespace IMIS.Application.AuditReportModule
{
    public class AuditReportDto : BaseDto<AuditReport, int>
    {
        public required string AuditPurpose { get; set; }
        public required string AuditConclusions { get; set; }

        public int? OfficeAuditedId { get; set; }
        public string? OfficeAuditedName { get; set; }

        public long? AuditStandardISOId { get; set; }
        public string? AuditStandardISOName { get; set; }

        public int? AuditeeId { get; set; }
        public string? AuditeeName { get; set; }

        // New: replaces DateofAuditId — pulls date/office/team through the plan entry
        public int? AuditPlanEntryId { get; set; }
        public DateTime? AuditDate { get; set; }
        public string? PlanOfficeProcess { get; set; }
        public string? PlanAuditTeamName { get; set; }

        public ICollection<AuditComFindingsDto> AuditComFindings { get; set; } = new List<AuditComFindingsDto>();
        public ICollection<AuditScopeDto> AuditScope { get; set; } = new List<AuditScopeDto>();
        public ICollection<AuditSummaryFindingsDto> AuditSummaryFindings { get; set; } = new List<AuditSummaryFindingsDto>();

        public AuditReportDto() { }

        [SetsRequiredMembers]
        public AuditReportDto(AuditReport entity)
        {
            Id = entity.Id;
            AuditPurpose = entity.AuditPurpose;
            AuditConclusions = entity.AuditConclisions;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            if (entity.OfficeAudited != null)
            {
                OfficeAuditedId = entity.OfficeAudited.Id;
                OfficeAuditedName = entity.OfficeAudited.ToString();
            }

            if (entity.AuditStandardISO != null)
            {
                AuditStandardISOId = entity.AuditStandardISO.Id;
                AuditStandardISOName = entity.AuditStandardISO.ToString();
            }

            if (entity.Auditee != null)
            {
                AuditeeId = entity.Auditee.Id;
                AuditeeName = entity.Auditee.ToString();
            }

            if (entity.AuditPlanEntry != null)
            {
                AuditPlanEntryId = entity.AuditPlanEntry.Id;
                AuditDate = entity.AuditPlanEntry.Time;

                var processes = entity.AuditPlanEntry.AuditPlanProcesses;
                if (processes != null && processes.Any())
                {
                    PlanOfficeProcess = string.Join(", ", processes
                        .Select(p => p.Office?.Name ?? p.ProcessName)
                        .Where(n => !string.IsNullOrWhiteSpace(n)));
                }

                var auditors = entity.AuditPlanEntry.IsoAuditors;
                if (auditors != null && auditors.Any())
                {
                    PlanAuditTeamName = auditors.FirstOrDefault(a => a.Team != null)?.Team?.Name;
                }
            }

            if (entity.AuditComFindings != null)
                AuditComFindings = entity.AuditComFindings.Select(x => new AuditComFindingsDto(x)).ToList();

            if (entity.AuditScope != null)
                AuditScope = entity.AuditScope.Select(x => new AuditScopeDto(x)).ToList();

            if (entity.AuditSummaryFIndings != null)
                AuditSummaryFindings = entity.AuditSummaryFIndings.Select(x => new AuditSummaryFindingsDto(x)).ToList();
        }

        public override AuditReport ToEntity()
        {
            return new AuditReport
            {
                Id = Id,
                AuditPurpose = AuditPurpose,
                AuditConclisions = AuditConclusions,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion,

                AuditComFindings = null,
                AuditScope = null,
                AuditSummaryFIndings = null
            };
        }
    }
}