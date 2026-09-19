using Base.Primitives;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace IMIS.Application.AuditPlanModule
{
    public class ReportAuditPlanDto : BaseDto<AuditPlan, int>
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public int AuditStatusId { get; set; }
        public string? StatusCode { get; set; }
        public string PlanStatus { get; set; } = string.Empty;

        public string BatchFormattedDates { get; set; } = string.Empty;

        public string AuditPlanObjective { get; set; } = string.Empty;
        public string ScopeOfAudit { get; set; } = string.Empty;

        public string PreparedByName { get; set; } = string.Empty;
        public string PreparedByDate { get; set; } = string.Empty;
        public string ApprovedByName { get; set; } = string.Empty;
        public string ApprovedByDate { get; set; } = string.Empty;

        public List<ReportScheduleEntryDto> FlatEntries { get; set; } = new();

        public ReportAuditPlanDto() { }

        [SetsRequiredMembers]
        public ReportAuditPlanDto(AuditPlan entity)
        {
            Id = entity.Id;
            StartDate = entity.StartDate;
            EndDate = entity.EndDate;

            AuditStatusId = entity.AuditStatusId;
            StatusCode = entity.AuditStatus?.Code;
            PlanStatus = entity.AuditStatus?.Name ?? "Draft";

            BatchFormattedDates = FormatDateRange(entity.StartDate, entity.EndDate);

            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            // NOTE: still empty unless the caller's query does
            // .Include(x => x.AuditProgramme) before constructing this DTO —
            // see fix notes, this class cannot load that itself.
            AuditPlanObjective = entity.AuditProgramme?.AuditPlanObjective ?? string.Empty;
            ScopeOfAudit = entity.AuditProgramme?.ScopeOfAudit ?? string.Empty;

            PreparedByName = ResolvePreparerName(entity.Preparer);
            PreparedByDate = entity.CreatedDate.ToString("MMMM dd, yyyy");

            var latestApproval = entity.Approvals?
                .Where(a => string.Equals(a.Action, "Approved", StringComparison.OrdinalIgnoreCase))
                .OrderByDescending(a => a.Timestamp)
                .FirstOrDefault();

            if (latestApproval != null)
            {
                ApprovedByName = ResolveUserName(latestApproval.Approver);
                ApprovedByDate = latestApproval.Timestamp.ToString("MMMM dd, yyyy");
            }

            if (entity.Entries != null)
            {
                foreach (var entry in entity.Entries.OrderBy(e => e.DayNumber).ThenBy(e => e.Time))
                {
                    string officeNamesCombined = "N/A";
                    if (entry.IsoAuditProcesses != null && entry.IsoAuditProcesses.Any())
                    {
                        officeNamesCombined = string.Join(Environment.NewLine, entry.IsoAuditProcesses
                            .Select(p => p.Name ?? "Unnamed Process"));
                    }
                    else if (entry.AuditPlanProcesses != null && entry.AuditPlanProcesses.Any())
                    {
                        officeNamesCombined = string.Join(Environment.NewLine, entry.AuditPlanProcesses
                            .Select(p =>
                            {
                                if (p.Office != null)
                                    return p.Office.Name ?? $"Office {p.OfficeId}";

                                if (!string.IsNullOrWhiteSpace(p.ProcessName))
                                    return p.ProcessName;

                                return p.OfficeId != null ? $"Office {p.OfficeId}" : $"Process {p.Id}";
                            }));
                    }

                    // FIX: Standard is now a plain typed field (entry.StandardText),
                    // matching the Flutter Plan page's free-text "STANDARD" column.
                    // The old IsoStandardAuditPlans join is kept as a fallback only,
                    // for any legacy entries that still carry that data instead.
                    string standardChaptersCombined = "N/A";
                    if (entry.IsoStandardAuditPlans != null && entry.IsoStandardAuditPlans.Any())
                    {
                        var clauses = entry.IsoStandardAuditPlans
                            .Select(s => s.IsoStandard != null ? s.IsoStandard.ClauseRef : s.IsoStandardId?.ToString())
                            .Where(clause => !string.IsNullOrEmpty(clause))
                            .OrderBy(clause => clause)
                            .ToList();

                        if (clauses.Any())
                            standardChaptersCombined = string.Join(", ", clauses);
                    }

                    // Team label ("Team 1", etc.) prefixed onto the responsible-names list —
                    // this part IS fixable now, since IsoAuditors/Team exists on this entity.
                    string? teamLabel = null;
                    if (entry.IsoAuditors != null && entry.IsoAuditors.Any())
                    {
                        var firstAuditorLink = entry.IsoAuditors.FirstOrDefault(a => a.TeamId != null);
                        if (firstAuditorLink != null)
                        {
                            teamLabel = firstAuditorLink.Team?.Name ?? $"Team {firstAuditorLink.TeamId}";
                        }
                    }

                    string auditorsLinesCombined;
                    if (entry.ResponsiblePersons != null && entry.ResponsiblePersons.Any())
                    {
                        var names = entry.ResponsiblePersons
                            .Select(r => r.Name ?? string.Empty)
                            .Where(n => !string.IsNullOrEmpty(n));
                        auditorsLinesCombined = teamLabel != null
                            ? teamLabel + Environment.NewLine + string.Join(Environment.NewLine, names)
                            : string.Join(Environment.NewLine, names);
                    }
                    else if (teamLabel != null)
                    {
                        auditorsLinesCombined = teamLabel;
                    }
                    else
                    {
                        auditorsLinesCombined = "Unassigned";
                    }

                    DateTime calculatedEntryDate = entity.StartDate.AddDays(entry.DayNumber - 1);

                    FlatEntries.Add(new ReportScheduleEntryDto
                    {
                        Id = entry.Id,
                        DayNumber = entry.DayNumber,
                        Time = entry.Time,
                        TotalDaysInBatch = entry.AuditPlan?.Entries?.Any() == true
                            ? entry.AuditPlan.Entries.Max(e => e.DayNumber)
                            : entry.DayNumber,
                        FormattedOfficeNames = officeNamesCombined.Trim(),
                        FormattedStandardChapters = standardChaptersCombined.Trim(),
                        FormattedProposedSchedule = calculatedEntryDate.ToString("MMMM dd, yyyy"),
                        FormattedAuditorTeamAndMembers = auditorsLinesCombined
                    });
                }
            }
        }

        public override AuditPlan ToEntity()
        {
            return new AuditPlan
            {
                Id = Id,
                StartDate = StartDate,
                EndDate = EndDate,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }

        private static string ResolvePreparerName(IsoAuditor? preparer)
        {
            return ResolveAuditorName(preparer?.IsoAuditors);
        }

        private static string ResolveAuditorName(Auditor? auditor)
        {
            return ResolveUserName(auditor?.User);
        }

        private static string ResolveUserName(User? user)
        {
            if (user == null) return string.Empty;

            var parts = new[] { user.Prefix, user.FirstName, user.MiddleName, user.LastName, user.Suffix }
                .Where(p => !string.IsNullOrWhiteSpace(p));

            return string.Join(" ", parts);
        }

        private static string FormatDateRange(DateTime start, DateTime end)
        {
            if (start.Month == end.Month && start.Year == end.Year)
            {
                if (start.Day == end.Day) return $"{start:MMMM dd, yyyy}";
                return $"{start:MMMM d} – {end:d, yyyy}";
            }
            return $"{start:MMMM dd, yyyy} - {end:MMMM dd, yyyy}";
        }
    }
}