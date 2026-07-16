using System;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditProgrammeModule
{
    public class ReportAuditProgrammeDto : BaseDto<AuditProgramme, int>
    {
        public int Year { get; set; }
        public string For { get; set; } = string.Empty;
        public string From { get; set; } = string.Empty;
        public string Purpose { get; set; } = string.Empty;
        public string ScopeAndFreqAudit { get; set; } = string.Empty;
        public string InternalAuditSched { get; set; } = string.Empty;
        public string AuditPlanObjective { get; set; } = string.Empty;
        public string ScopeOfAudit { get; set; } = string.Empty;

        public List<ReportObjectiveItemDto> Objectives { get; set; } = new();
        public List<ReportAuditPlanBatchDto> AuditPlan { get; set; } = new();

        // FLAT list — all entries from all plans in order.
        // FastReport DataBand binds to AuditData.FlatEntries so every row appears.
        public List<ReportScheduleEntryDto> FlatEntries { get; set; } = new();

        public ReportAuditProgrammeDto() { }

        [SetsRequiredMembers]
        public ReportAuditProgrammeDto(AuditProgramme entity)
        {
            Id = entity.Id;
            Year = entity.Year;
            For = entity.For ?? string.Empty;
            From = entity.From ?? string.Empty;
            Purpose = entity.Purpose ?? string.Empty;
            ScopeAndFreqAudit = entity.ScopeAndFreqAudit ?? string.Empty;
            InternalAuditSched = entity.InternalAuditSched ?? string.Empty;
            AuditPlanObjective = entity.AuditPlanObjective ?? string.Empty;
            ScopeOfAudit = entity.ScopeOfAudit ?? string.Empty;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;

            Objectives = entity.Objectives?
                .OrderBy(o => o.SortOrder)
                .Select(o => new ReportObjectiveItemDto
                {
                    Id = o.Id,
                    Text = o.Description ?? string.Empty
                })
                .ToList() ?? new List<ReportObjectiveItemDto>();

            if (entity.AuditPlans != null)
            {
                int batchCounter = 1;
                foreach (var plan in entity.AuditPlans.OrderBy(p => p.StartDate))
                {
                    var reportBatch = new ReportAuditPlanBatchDto
                    {
                        Id = plan.Id,
                        StartDate = plan.StartDate,
                        EndDate = plan.EndDate,
                        PlanStatus = plan.PlanStatus ?? "Draft",
                        BatchIndexString = batchCounter.ToString(),
                        BatchFormattedDates = FormatBatchDateRange(plan.StartDate, plan.EndDate),
                        Entries = new List<ReportScheduleEntryDto>()
                    };

                    if (plan.Entries != null)
                    {
                        int maxDay = plan.Entries.Any() ? plan.Entries.Max(e => e.DayNumber) : 1;

                        foreach (var entry in plan.Entries.OrderBy(e => e.DayNumber).ThenBy(e => e.Time))
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
                                    .Select(p => p.Office != null ? (p.Office.Name ?? $"Office {p.OfficeId}") : $"Office {p.OfficeId}"));
                            }

                            string standardChaptersCombined = "N/A";
                            if (entry.IsoStandardAuditPlans != null && entry.IsoStandardAuditPlans.Any())
                            {
                                var clauses = entry.IsoStandardAuditPlans
                                    .Select(s => s.IsoStandard != null ? s.IsoStandard.ClauseRef : s.IsoStandardId.ToString())
                                    .Where(clause => !string.IsNullOrEmpty(clause))
                                    .OrderBy(clause => clause)
                                    .ToList();

                                if (clauses.Any())
                                    standardChaptersCombined = string.Join(", ", clauses);
                            }

                            string auditorsLinesCombined = "Unassigned";
                            if (entry.IsoAuditors != null && entry.IsoAuditors.Any())
                            {
                                var auditorLines = new List<string>();

                                string teamName = entry.IsoAuditors.FirstOrDefault(a => a.Team != null)?.Team?.Name
                                               ?? $"Team {entry.IsoAuditors.FirstOrDefault(a => a.TeamId != null)?.TeamId ?? 1}";

                                auditorLines.Add(teamName);
                                auditorLines.Add(string.Empty);

                                int regularAuditorIndex = 1;
                                foreach (var item in entry.IsoAuditors)
                                {
                                    string fullName = "Staff Auditor";
                                    var userObj = item.GetType().GetProperty("Auditor")?.GetValue(item);
                                    if (userObj != null)
                                        fullName = userObj.GetType().GetProperty("Name")?.GetValue(userObj)?.ToString() ?? fullName;

                                    bool isSpecialObserver = item.TeamId == null || item.AuditorId == 0;
                                    auditorLines.Add(isSpecialObserver ? $"* {fullName}" : $"{regularAuditorIndex++}. {fullName}");
                                }

                                auditorsLinesCombined = string.Join(Environment.NewLine, auditorLines);
                            }

                            DateTime calculatedEntryDate = plan.StartDate.AddDays(entry.DayNumber - 1);

                            var scheduleEntry = new ReportScheduleEntryDto
                            {
                                Id = entry.Id,
                                DayNumber = entry.DayNumber,
                                Time = entry.Time,
                                TotalDaysInBatch = maxDay,
                                FormattedOfficeNames = officeNamesCombined.Trim(),
                                FormattedStandardChapters = standardChaptersCombined.Trim(),
                                FormattedProposedSchedule = calculatedEntryDate.ToString("MMMM dd, yyyy"),
                                FormattedAuditorTeamAndMembers = auditorsLinesCombined
                            };

                            reportBatch.Entries.Add(scheduleEntry);

                            // Also add to the flat list for FastReport DataBand iteration
                            FlatEntries.Add(scheduleEntry);
                        }
                    }

                    AuditPlan.Add(reportBatch);
                    batchCounter++;
                }
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
                RowVersion = RowVersion
            };
        }

        private static string FormatBatchDateRange(DateTime start, DateTime end)
        {
            if (start.Month == end.Month && start.Year == end.Year)
            {
                if (start.Day == end.Day) return $"{start:MMMM dd, yyyy}";
                return $"{start:MMMM d} – {end:d, yyyy}";
            }
            return $"{start:MMMM dd, yyyy} - {end:MMMM dd, yyyy}";
        }
    }

    public class ReportObjectiveItemDto
    {
        public long Id { get; set; }
        public string Text { get; set; } = string.Empty;
    }

    public class ReportAuditPlanBatchDto
    {
        public int Id { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string PlanStatus { get; set; } = string.Empty;
        public string BatchIndexString { get; set; } = string.Empty;
        public string BatchFormattedDates { get; set; } = string.Empty;
        public List<ReportScheduleEntryDto> Entries { get; set; } = new();
    }

    public class ReportScheduleEntryDto
    {
        public int Id { get; set; }
        public int DayNumber { get; set; }
        public DateTime Time { get; set; }
        public int TotalDaysInBatch { get; set; }
        public string FormattedOfficeNames { get; set; } = string.Empty;
        public string FormattedStandardChapters { get; set; } = string.Empty;
        public string FormattedProposedSchedule { get; set; } = string.Empty;
        public string FormattedAuditorTeamAndMembers { get; set; } = string.Empty;
    }
}
