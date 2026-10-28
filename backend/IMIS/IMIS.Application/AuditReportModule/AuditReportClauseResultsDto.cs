using System.Collections.Generic;

namespace IMIS.Application.AuditReportModule
{
    /// <summary>
    /// Every clause result of one audit schedule's checklist (conforming and
    /// non-conforming), as listed in the Audit Report of the audited office.
    /// </summary>
    public class AuditReportClauseResultsDto
    {
        public int AuditScheduleId { get; set; }
        public int ConformingCount { get; set; }
        public int NonConformingCount { get; set; }
        public int PendingCount { get; set; }
        public List<AuditReportClauseResultDto> Items { get; set; } = new();
    }

    public class AuditReportClauseResultDto
    {
        public int AuditChecklistId { get; set; }
        public string ClauseRef { get; set; } = string.Empty;
        public string Question { get; set; } = string.Empty;

        /// <summary>True = conforming, false = non-conforming, null = not answered yet.</summary>
        public bool? Conforming { get; set; }
        public string? FindingAndRemarks { get; set; }

        /// <summary>The NCAR raised for a non-conforming clause.</summary>
        public long? NcarId { get; set; }
        public string? NcarReferenceNumber { get; set; }
        public string? NcarStatus { get; set; }
    }
}
