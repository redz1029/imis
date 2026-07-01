using System;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.AuditPlanModule;
using IMIS.Domain;

namespace IMIS.Application.AuditProgrammeModule
{
    public class ReportAuditProgrammeDto : BaseDto<AuditProgramme, int>
    {
        // Master Narrative Properties
        public int Year { get; set; }
        public string For { get; set; } = string.Empty;
        public string From { get; set; } = string.Empty;
        public string Purpose { get; set; } = string.Empty;
        public string ScopeAndFreqAudit { get; set; } = string.Empty;
        public string InternalAuditSched { get; set; } = string.Empty;
        public string AuditPlanObjective { get; set; } = string.Empty;
        public string ScopeOfAudit { get; set; } = string.Empty;

        // Structured Layout DataBand Collections
        public List<ReportObjectiveItemDto> Objectives { get; set; } = new();
        public List<ReportAuditPlanBatchDto> AuditPlan { get; set; } = new();

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

            // 1. Map Objectives List Safely using the corrected Description property
            if (entity.Objectives != null)
            {
                Objectives = entity.Objectives
                    .OrderBy(o => o.SortOrder)
                    .Select(o => new ReportObjectiveItemDto
                    {
                        Id = o.Id,
                        Text = o.Description ?? string.Empty
                    })
                    .ToList();
            }

            // 2. Map and Flatten the Multi-Tiered Batches using corrected AuditPlan collection
            if (entity.AuditPlans != null)
            {
                var plansList = entity.AuditPlans as IEnumerable<AuditPlan> ?? new List<AuditPlan> { entity.AuditPlans as AuditPlan };

                int batchCounter = 1;
                foreach (var plan in plansList.Where(p => p != null).OrderBy(p => p.StartDate))
                {
                    var reportBatch = new ReportAuditPlanBatchDto
                    {
                        Id = plan.Id,
                        StartDate = plan.StartDate,
                        EndDate = plan.EndDate,
                        PlanStatus = plan.PlanStatus ?? "Draft",
                        BatchIndexString = batchCounter.ToString(),
                        BatchFormattedDates = FormatBatchDateRange(plan.StartDate, plan.EndDate)
                    };

                    if (plan.Entries != null)
                    {
                        int maxDay = plan.Entries.Any() ? plan.Entries.Max(e => e.DayNumber) : 1;

                        foreach (var entry in plan.Entries.OrderBy(e => e.DayNumber).ThenBy(e => e.Time))
                        {
                            // -----------------------------------------------------------------
                            // Safe Value Extraction from Structural Normalized Domain Tables
                            // -----------------------------------------------------------------

                            // 1. Offices / Processes Naming
                            string officeNamesCombined = "N/A";
                            if (entry.AuditPlanProcesses != null && entry.AuditPlanProcesses.Any())
                            {
                                officeNamesCombined = string.Join(", ", entry.AuditPlanProcesses
                                    .Select(p => p.Office != null ? (p.Office.Name ?? $"Office {p.OfficeId}") : $"Office {p.OfficeId}"));
                            }
                            else if (entry.IsoAuditProcesses != null && entry.IsoAuditProcesses.Any())
                            {
                                officeNamesCombined = string.Join(", ", entry.IsoAuditProcesses
                                    .Select(p => p.Name ?? "Unnamed Process"));
                            }

                            // 2. Standards Text Mapping via ClauseRef and Particulars properties
                            string standardChaptersCombined = "N/A";
                            if (entry.IsoStandardAuditPlans != null && entry.IsoStandardAuditPlans.Any())
                            {
                                standardChaptersCombined = string.Join(", ", entry.IsoStandardAuditPlans
                                    .Select(s => s.IsoStandard != null
                                        ? (!string.IsNullOrEmpty(s.IsoStandard.ClauseRef) ? $"{s.IsoStandard.ClauseRef} - {s.IsoStandard.Particulars}" : s.IsoStandard.Particulars)
                                        : $"ISO Std {s.IsoStandardId}"));
                            }

                            // 3. User Lookup Naming safely drilling into User Entity Profile references
                            string auditorsLinesCombined = "Unassigned";
                            if (entry.IsoAuditors != null && entry.IsoAuditors.Any())
                            {
                                auditorsLinesCombined = string.Join(Environment.NewLine, entry.IsoAuditors
                                    .Select(a => {
                                        if (a.IsoAuditors?.User != null)
                                        {
                                            return $"{a.IsoAuditors.User.FirstName} {a.IsoAuditors.User.LastName}".Trim();
                                        }
                                        return !string.IsNullOrEmpty(a.AuditorId) ? $"Auditor: {a.AuditorId}" : "Staff Auditor";
                                    }));
                            }

                            // Add fully mapped entry to output DTO batch
                            reportBatch.Entries.Add(new ReportScheduleEntryDto
                            {
                                Id = entry.Id,
                                DayNumber = entry.DayNumber,
                                Time = entry.Time,
                                TotalDaysInBatch = maxDay,

                                FormakedOfficeNames = officeNamesCombined.Trim(),
                                FormattedStandardChapters = standardChaptersCombined.Trim(),
                                FormattedProposedSchedule = entry.Time.ToString("hh:mm tt"),
                                FormattedAuditorTeamAndMembers = auditorsLinesCombined
                            });
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
                var days = Enumerable.Range(start.Day, end.Day - start.Day + 1);
                return $"{start:MMMM} {string.Join(", ", days)}, {start:yyyy}";
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
        public string FormakedOfficeNames { get; set; } = string.Empty;
        public string FormattedStandardChapters { get; set; } = string.Empty;
        public string FormattedProposedSchedule { get; set; } = string.Empty;
        public string FormattedAuditorTeamAndMembers { get; set; } = string.Empty;
    }
}