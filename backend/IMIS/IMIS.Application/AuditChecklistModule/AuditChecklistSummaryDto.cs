using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.AuditChecklistModule
{
    /// <summary>
    /// One row of the Audit Checklist list page. Dynamically generated from
    /// Audit Schedule records (in schedule order), NOT from a hardcoded team
    /// roster. The team name is purely a display value — AuditScheduleId is
    /// the unique identifier the frontend uses to load the full checklist.
    /// </summary>
    public class AuditChecklistSummaryDto
    {
        public int AuditScheduleId { get; set; }
        public int? TeamId { get; set; }
        public string? TeamName { get; set; }
        public string? OfficeProcess { get; set; }
        public string? AuditScope { get; set; }
        public string? AuditorNames { get; set; }
        public string? Auditees { get; set; }
        public int ClauseCount { get; set; }
        public string? StatusName { get; set; }

        public AuditChecklistSummaryDto() { }
    }
}