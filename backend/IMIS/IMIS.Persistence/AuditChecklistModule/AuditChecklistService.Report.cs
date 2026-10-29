using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditChecklistModule
{
    /// <summary>
    /// Checklist -> Audit Report: an audit report is never typed in. It is raised
    /// by the first saved checklist row of a schedule and then kept in step with
    /// the checklist: the auditees, and one Summary-of-Findings line per
    /// non-conforming clause (each carrying its NCAR). Only the commendable
    /// findings, the purpose and the conclusions are written by hand on the report.
    /// </summary>
    public partial class AuditChecklistService
    {
        private const string AuditReportEntityType = "AuditReport";
        private const string DefaultAuditPurpose = "INTERNAL QUALITY AUDIT";
        private const string NonconformityStatusName = "NC";

        /// <summary>Raises / refreshes the report of the schedule the saved row belongs to.</summary>
        private async Task SyncAuditReportForRowAsync(int checklistId, CancellationToken cancellationToken)
        {
            var scheduleId = await _dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => c.Id == checklistId && !c.IsDeleted)
                .Select(c => (int?)c.AuditScheduleId)
                .FirstOrDefaultAsync(cancellationToken)
                .ConfigureAwait(false);
            if (scheduleId == null) return;

            await SyncAuditReportAsync(scheduleId.Value, cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Raises the report of every schedule that already has answered checklist
        /// rows but no report yet (checklists saved before reports were automatic).
        /// Existing reports are left alone.
        /// </summary>
        public async Task<int> SyncMissingAuditReportsAsync(CancellationToken cancellationToken)
        {
            var scheduleIds = await _dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => !c.IsDeleted && c.Conforming != null)
                .Select(c => c.AuditScheduleId)
                .Distinct()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
            if (scheduleIds.Count == 0) return 0;

            // Soft-deleted reports are included on purpose: the sync revives them
            // rather than raising a second report for the same schedule.
            var withReport = await _dbContext.Set<AuditReport>()
                .IgnoreQueryFilters()
                .AsNoTracking()
                .Where(r => scheduleIds.Contains(r.AuditScheduleId))
                .Select(r => r.AuditScheduleId)
                .Distinct()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            var missing = scheduleIds.Except(withReport).ToList();
            foreach (var scheduleId in missing)
                await SyncAuditReportAsync(scheduleId, cancellationToken).ConfigureAwait(false);

            return missing.Count;
        }

        private async Task SyncAuditReportAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            var rows = await _dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => c.AuditScheduleId == auditScheduleId && !c.IsDeleted)
                .Select(c => new ReportRow
                {
                    Id = c.Id,
                    AuditPlanEntryId = c.AuditPlanEntryId,
                    ClauseRef = c.AuditChecklistQNA!.IsoStandard!.ClauseRef,
                    Question = c.AuditChecklistQNA.Question,
                    Conforming = c.Conforming,
                    FindingAndRemarks = c.FindingAndRemarks,
                    Auditees = c.Auditees
                })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
            if (rows.Count == 0) return;

            var planEntryId = rows[0].AuditPlanEntryId;

            // A schedule has one report. A soft-deleted one is brought back
            // instead of raising a second.
            var report = await _dbContext.Set<AuditReport>()
                .IgnoreQueryFilters()
                .Include(r => r.AuditScope)
                .Include(r => r.AuditSummaryFIndings)
                .Where(r => r.AuditScheduleId == auditScheduleId)
                .OrderBy(r => r.IsDeleted)
                .ThenBy(r => r.Id)
                .FirstOrDefaultAsync(cancellationToken)
                .ConfigureAwait(false);

            // Once the report is with the approvers it is frozen: a later
            // checklist edit must not change what they are signing.
            if (report != null && await IsAuditReportSubmittedAsync(report.Id, cancellationToken).ConfigureAwait(false))
                return;

            var entry = await _dbContext.Set<AuditPlanEntry>()
                .AsNoTracking()
                .Where(e => e.Id == planEntryId)
                .Select(e => new
                {
                    ProcessId = e.AuditPlanProcesses!.OrderBy(p => p.Id).Select(p => (int?)p.Id).FirstOrDefault(),
                    StandardId = e.IsoStandardAuditPlans!.OrderBy(s => s.Id).Select(s => s.IsoStandardId).FirstOrDefault(),
                    Responsible = e.ResponsiblePersons!.Select(p => p.Name).ToList()
                })
                .FirstOrDefaultAsync(cancellationToken)
                .ConfigureAwait(false);

            if (report == null)
            {
                report = new AuditReport
                {
                    Id = 0,
                    AuditPurpose = DefaultAuditPurpose,
                    AuditConclisions = string.Empty,
                    AuditScheduleId = auditScheduleId,
                    AuditPlanEntryId = planEntryId,
                    AuditScope = new List<AuditScope>(),
                    AuditSummaryFIndings = new List<AuditSummaryFIndings>()
                };
                _dbContext.Set<AuditReport>().Add(report);
            }

            report.IsDeleted = false;
            report.AuditPlanEntryId ??= planEntryId;

            var reportEntry = _dbContext.Entry(report);
            if (reportEntry.Property<int?>("OfficeAuditedId").CurrentValue == null)
                reportEntry.Property<int?>("OfficeAuditedId").CurrentValue = entry?.ProcessId;
            if (reportEntry.Property<long?>("AuditStandardISOId").CurrentValue == null)
                reportEntry.Property<long?>("AuditStandardISOId").CurrentValue = entry?.StandardId;

            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            // Auditees: what the checklist names, else the plan entry's
            // responsible persons. With neither, whatever is stored stays.
            var auditees = rows
                .SelectMany(r => SplitNames(r.Auditees))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();
            if (auditees.Count == 0 && entry != null)
                auditees = entry.Responsible
                    .SelectMany(SplitNames)
                    .Distinct(StringComparer.OrdinalIgnoreCase)
                    .ToList();

            if (auditees.Count > 0)
            {
                _dbContext.Set<AuditScope>().RemoveRange(report.AuditScope ?? new List<AuditScope>());
                foreach (var name in auditees)
                {
                    _dbContext.Set<AuditScope>().Add(new AuditScope
                    {
                        Id = 0,
                        Auditee = name,
                        AuditReportId = report.Id,
                        IsDeleted = false
                    });
                }
            }

            // Summary of Findings: one NC line per non-conforming clause.
            var ncRows = rows
                .Where(r => r.Conforming == false)
                .OrderBy(r => r.ClauseRef, new ClauseNumberComparer())
                .ToList();
            var ncRowIds = ncRows.Select(r => r.Id).ToList();

            var ncars = ncRowIds.Count == 0
                ? new List<NonconformingActionReport>()
                : await _dbContext.Set<NonconformingActionReport>()
                    .Where(n => n.AuditChecklistId != null && ncRowIds.Contains(n.AuditChecklistId.Value))
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
            var ncarByRow = ncars.ToDictionary(n => n.AuditChecklistId!.Value);

            var ncStatusId = await _dbContext.Set<AuditNcarStatus>()
                .AsNoTracking()
                .Where(s => s.ncarStatus != null && s.ncarStatus.Trim().ToUpper() == NonconformityStatusName)
                .Select(s => (int?)s.Id)
                .FirstOrDefaultAsync(cancellationToken)
                .ConfigureAwait(false);

            _dbContext.Set<AuditSummaryFIndings>().RemoveRange(report.AuditSummaryFIndings ?? new List<AuditSummaryFIndings>());
            var no = 1;
            foreach (var row in ncRows)
            {
                var finding = string.IsNullOrWhiteSpace(row.FindingAndRemarks)
                    ? row.Question
                    : row.FindingAndRemarks.Trim();
                var text = $"{row.ClauseRef.Trim()} - {finding}";
                if (ncarByRow.TryGetValue(row.Id, out var ncar))
                {
                    text += $" (NCAR {ncar.ReferenceNumber})";
                    ncar.AuditReportId = report.Id;
                }

                _dbContext.Set<AuditSummaryFIndings>().Add(new AuditSummaryFIndings
                {
                    Id = 0,
                    No = no++,
                    Findings = text,
                    AuditNcarStatusId = ncStatusId,
                    AuditReportId = report.Id,
                    IsDeleted = false
                });
            }

            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
        }

        private Task<bool> IsAuditReportSubmittedAsync(int auditReportId, CancellationToken cancellationToken) =>
            _dbContext.Set<IQASignatory>()
                .AsNoTracking()
                .AnyAsync(s => s.AuditEntityType == AuditReportEntityType
                               && s.AuditEntityId == auditReportId
                               && !s.IsDeleted, cancellationToken);

        private static IEnumerable<string> SplitNames(string? names) =>
            (names ?? string.Empty)
                .Split(new[] { ',', ';', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);

        private sealed class ReportRow
        {
            public int Id { get; init; }
            public int AuditPlanEntryId { get; init; }
            public string ClauseRef { get; init; } = string.Empty;
            public string Question { get; init; } = string.Empty;
            public bool? Conforming { get; init; }
            public string? FindingAndRemarks { get; init; }
            public string? Auditees { get; init; }
        }
    }
}
