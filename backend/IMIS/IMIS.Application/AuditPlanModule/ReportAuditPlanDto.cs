using Base.Primitives;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Application.IQASignatoryModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace IMIS.Application.AuditPlanModule
{
    public class ReportAuditPlanDto : BaseDto<AuditPlan, int>
    {
        public string PlanName { get; set; } = string.Empty;
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        // Derived from IQASignatory rows — never stored as a column on AuditPlan.
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
            PlanName = entity.PlanName;
            StartDate = entity.StartDate;
            EndDate = entity.EndDate;

            // Derive status from the live signatory chain.
            // Callers must load IQASignatories (non-deleted) or this reads as Draft.
            var signatories = IQAApprovalWorkflow.Ordered(entity.IQASignatories);
            var stateCode = IQAApprovalWorkflow.DeriveStateCode(signatories);
            StatusCode = stateCode;
            PlanStatus = IQAApprovalWorkflow.StateName(stateCode);

            BatchFormattedDates = FormatDateRange(entity.StartDate, entity.EndDate);

            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            // NOTE: still empty unless the caller's query does
            // .Include(x => x.AuditProgramme) before constructing this DTO —
            // this class cannot load that itself.
            AuditPlanObjective = entity.AuditProgramme?.AuditPlanObjective ?? string.Empty;
            ScopeOfAudit = entity.AuditProgramme?.ScopeOfAudit ?? string.Empty;

            PreparedByName = ResolvePreparerName(entity.Preparer);
            PreparedByDate = entity.CreatedDate.ToString("MMMM dd, yyyy");

            // "Approved by" is the last person to sign, and only once the
            // whole chain has approved.
            if (stateCode == IQAApprovalWorkflow.StateCodes.Approved)
            {
                var finalSigner = signatories
                    .Where(s => s.DateSigned != null)
                    .OrderByDescending(s => s.DateSigned)
                    .FirstOrDefault();

                if (finalSigner != null)
                {
                    ApprovedByName = ResolveUserName(finalSigner.Signatory);
                    ApprovedByDate = finalSigner.DateSigned!.Value.ToString("MMMM dd, yyyy");
                }
            }

            if (entity.Entries != null)
            {
                int maxDay = entity.Entries.Any() ? entity.Entries.Max(e => e.DayNumber) : 1;

                foreach (var entry in entity.Entries.OrderBy(e => e.DayNumber).ThenBy(e => e.Time))
                {
                    // ---------------- Organizational unit / process ----------------
                    string officeNamesCombined = "N/A";
                    if (entry.IsoAuditProcesses != null && entry.IsoAuditProcesses.Any())
                    {
                        officeNamesCombined = string.Join(
                            Environment.NewLine,
                            entry.IsoAuditProcesses.Select(p => p.Name ?? "Unnamed Process"));
                    }
                    else if (entry.AuditPlanProcesses != null && entry.AuditPlanProcesses.Any())
                    {
                        officeNamesCombined = string.Join(
                            Environment.NewLine,
                            entry.AuditPlanProcesses.Select(p =>
                            {
                                if (p.Office != null)
                                    return p.Office.Name ?? $"Office {p.OfficeId}";
                                if (!string.IsNullOrWhiteSpace(p.ProcessName))
                                    return p.ProcessName;
                                return p.OfficeId != null ? $"Office {p.OfficeId}" : $"Process {p.Id}";
                            }));
                    }

                    // ---------------- Standard / clause refs ----------------
                    string standardChaptersCombined = "N/A";
                    if (entry.IsoStandardAuditPlans != null && entry.IsoStandardAuditPlans.Any())
                    {
                        var clauses = entry.IsoStandardAuditPlans
                            .Select(s => s.IsoStandard != null
                                ? s.IsoStandard.ClauseRef
                                : s.IsoStandardId?.ToString())
                            .Where(c => !string.IsNullOrEmpty(c))
                            .OrderBy(c => c)
                            .ToList();

                        if (clauses.Any())
                            standardChaptersCombined = string.Join(", ", clauses);
                    }

                    // ---------------- Audit team / responsible persons ----------------
                    string? teamLabel = null;
                    if (entry.IsoAuditors != null && entry.IsoAuditors.Any())
                    {
                        var firstWithTeam = entry.IsoAuditors.FirstOrDefault(a => a.TeamId != null);
                        if (firstWithTeam != null)
                            teamLabel = firstWithTeam.Team?.Name ?? $"Team {firstWithTeam.TeamId}";
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
                        TotalDaysInBatch = maxDay,
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
                PlanName = PlanName,
                StartDate = StartDate,
                EndDate = EndDate,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }

        private static string ResolvePreparerName(IsoAuditor? preparer) =>
            ResolveAuditorName(preparer?.IsoAuditors);

        private static string ResolveAuditorName(Auditor? auditor) =>
            ResolveUserName(auditor?.User);

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
