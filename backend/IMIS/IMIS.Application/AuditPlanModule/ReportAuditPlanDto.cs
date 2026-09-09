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
        public string PlanStatus { get; set; } = string.Empty;
        public string BatchFormattedDates { get; set; } = string.Empty;

        // Pulled from the parent AuditProgramme — AuditPlan itself has no
        // AuditPlanObjective/ScopeOfAudit fields (confirmed against the
        // AuditPlan domain class). Requires AuditPlan.AuditProgramme to be
        // included by whatever query builds this DTO, or these come back
        // empty.
        public string AuditPlanObjective { get; set; } = string.Empty;
        public string ScopeOfAudit { get; set; } = string.Empty;

        // Signature block — no equivalent existed on ReportAuditProgrammeDto
        // at all; the Audit Programme report has no Prepared-by/Approved-by
        // band. Added here since the printed Audit Plan document has one.
        public string PreparedByName { get; set; } = string.Empty;
        public string PreparedByDate { get; set; } = string.Empty;
        public string ApprovedByName { get; set; } = string.Empty;
        public string ApprovedByDate { get; set; } = string.Empty;

        // FLAT list — every entry in this plan, in Day/Time order.
        // FastReport's DataBand binds to AuditData.FlatEntries, same
        // convention as ReportAuditProgrammeDto. Reuses the existing
        // ReportScheduleEntryDto shape rather than duplicating it.
        public List<ReportScheduleEntryDto> FlatEntries { get; set; } = new();

        public ReportAuditPlanDto() { }

        [SetsRequiredMembers]
        public ReportAuditPlanDto(AuditPlan entity)
        {
            Id = entity.Id;
            StartDate = entity.StartDate;
            EndDate = entity.EndDate;
            PlanStatus = entity.PlanStatus ?? "Draft";
            BatchFormattedDates = FormatDateRange(entity.StartDate, entity.EndDate);

            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            // ASSUMPTION: AuditPlanObjective/ScopeOfAudit come from the
            // parent Programme. If AuditProgramme isn't loaded on this
            // entity, both fall back to empty strings rather than throwing.
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

                    // Prefer named ResponsiblePersons (this is what carries
                    // "Opening Meeting" attendee roles and any named-auditor
                    // overrides); fall back to the assigned Team's display
                    // name when no individual has been named for this entry.
                    string auditorsLinesCombined = "Unassigned";
                    if (entry.ResponsiblePersons != null && entry.ResponsiblePersons.Any())
                    {
                        auditorsLinesCombined = string.Join(Environment.NewLine, entry.ResponsiblePersons
                            .Select(r => r.Name ?? string.Empty)
                            .Where(n => !string.IsNullOrEmpty(n)));
                    }
                    else if (entry.IsoAuditors != null && entry.IsoAuditors.Any())
                    {
                        string teamName = entry.IsoAuditors.FirstOrDefault(a => a.Team != null)?.Team?.Name
                                       ?? $"Team {entry.IsoAuditors.FirstOrDefault(a => a.TeamId != null)?.TeamId ?? 1}";
                        auditorsLinesCombined = teamName;
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
                PlanStatus = PlanStatus,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }

        private static string ResolvePreparerName(IsoAuditor? preparer)
        {
            // NOTE: IsoAuditor.IsoAuditors is the (oddly named) Auditor?
            // navigation on that entity — not a typo here, matching the
            // actual domain class.
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