using Base.Primitives;
using IMIS.Domain;
using System;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace IMIS.Application.AuditScheduleModule
{
    public class ReportAuditScheduleDto : BaseDto<AuditSchedule, int>
    {
        public string AuditeeOfficeName { get; set; } = string.Empty;
        public string AuditTeamNumber { get; set; } = string.Empty;

        // Team roster (individual member names) is not resolvable from the
        // Team entity as confirmed — only Team.Name is available. Wire in
        // a real roster join here if/when that shape is confirmed.
        public string FormattedAuditTeamMembers { get; set; } = string.Empty;

        public string Purpose { get; set; } = string.Empty;
        public string FormattedAuditDate { get; set; } = string.Empty;

        public string FormattedTime { get; set; } = string.Empty;
        public string Activity { get; set; } = string.Empty;
        public string FormattedCriteria { get; set; } = string.Empty;
        public string FormattedPersonResponsible { get; set; } = string.Empty;

        // AuditSchedule carries no Preparer/Approver fields of its own.
        // IQASignatories exists on the entity but its role shape (Team
        // Leader vs Auditee/Head of Office) isn't confirmed, so these stay
        // blank rather than guessed at.
        public string PreparedByName { get; set; } = string.Empty;
        public string PreparedByDate { get; set; } = string.Empty;
        public string ApprovedByName { get; set; } = string.Empty;
        public string ApprovedByDate { get; set; } = string.Empty;

        public ReportAuditScheduleDto() { }

        [SetsRequiredMembers]
        public ReportAuditScheduleDto(AuditSchedule entity)
        {
            Id = entity.Id;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            Purpose = entity.Purpose ?? string.Empty;
            Activity = entity.Activity ?? string.Empty;
            FormattedAuditDate = entity.StartDate.ToString("MMMM dd, yyyy");

            AuditTeamNumber = entity.TeamId?.ToString() ?? string.Empty;
            FormattedAuditTeamMembers = entity.Team?.Name ?? string.Empty;

            var entry = entity.AuditPlanEntry;
            if (entry != null)
            {
                FormattedTime = entry.Time.ToString("h:mm tt");

                if (entry.AuditPlanProcesses != null && entry.AuditPlanProcesses.Any())
                {
                    var first = entry.AuditPlanProcesses.First();
                    AuditeeOfficeName = first.Office?.Name
                        ?? (!string.IsNullOrWhiteSpace(first.ProcessName) ? first.ProcessName! : string.Empty);
                }

                if (entry.IsoStandardAuditPlans != null && entry.IsoStandardAuditPlans.Any())
                {
                    var clauses = entry.IsoStandardAuditPlans
                        .Where(s => s.IsoStandard != null && !string.IsNullOrEmpty(s.IsoStandard.ClauseRef))
                        .Select(s => s.IsoStandard.ClauseRef)
                        .OrderBy(c => c)
                        .ToList();
                    if (clauses.Any())
                        FormattedCriteria = string.Join(", ", clauses);
                }

                if (entry.ResponsiblePersons != null && entry.ResponsiblePersons.Any())
                {
                    FormattedPersonResponsible = string.Join(
                        Environment.NewLine,
                        entry.ResponsiblePersons.Select(r => r.Name ?? string.Empty).Where(n => !string.IsNullOrEmpty(n)));
                }
            }
        }

        public override AuditSchedule ToEntity()
        {
            return new AuditSchedule
            {
                Id = Id,
                Purpose = Purpose,
                Activity = Activity,
                IsActive = true,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion,
                AuditPlanEntryId = 0
            };
        }
    }
}