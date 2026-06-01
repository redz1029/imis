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
        // Primitive Properties
        public required string AuditPurpose { get; set; }
        public required string AuditConclusions { get; set; }

        // Parent Navigation Property Information
        public int? OfficeAuditedId { get; set; }
        public string? OfficeAuditedName { get; set; }

        public long? AuditStandardISOId { get; set; }
        public string? AuditStandardISOName { get; set; }

        public int? DateofAuditId { get; set; }
        public string? AuditPlanTitle { get; set; }

        // Child Collection DTOs for Complete Data Payload Graph
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

            if (entity.DateofAudit != null)
            {
                DateofAuditId = entity.DateofAudit.Id;
                AuditPlanTitle = entity.DateofAudit.ToString();
            }

            if (entity.AuditComFindings != null)
            {
                AuditComFindings = entity.AuditComFindings
                    .Select(x => new AuditComFindingsDto(x))
                    .ToList();
            }

            if (entity.AuditScope != null)
            {
                AuditScope = entity.AuditScope
                    .Select(x => new AuditScopeDto(x))
                    .ToList();
            }

            if (entity.AuditSummaryFIndings != null)
            {
                AuditSummaryFindings = entity.AuditSummaryFIndings
                    .Select(x => new AuditSummaryFindingsDto(x))
                    .ToList();
            }
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

                // FIXED PERFECTLY: Leave collections empty/null here. 
                // Let your AuditReportService map or clear relationships explicitly 
                // to completely bypass EF Core temporary state tracing crashes.
                AuditComFindings = null,
                AuditScope = null,
                AuditSummaryFIndings = null
            };
        }
    }
}