using IMIS.Application.IQASignatoryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditScheduleModule
{
    /// <summary>
    /// Creates the Audit Schedules of an APPROVED Audit Plan: one per audited
    /// office, carrying the team the plan assigned to that office. The schedules
    /// are only created here — the Auditor Team Leader of that team submits them.
    /// Safe to call again: an office that already has a schedule is skipped.
    /// Only adds tracked entities; the caller commits.
    /// </summary>
    public static class AuditScheduleGenerator
    {
        public const string DefaultPurpose = "Internal Quality Audit";

        public const string DefaultActivity =
            "Opening Activity\n" +
            "Introduction of Auditors\n" +
            "Audit Proper\n" +
            "-Interview\n" +
            "-Observation\n" +
            "-Documented Information Review\n\n" +
            "Closing Meeting\n" +
            "-Audit findings";

        private static bool IsMeetingRow(AuditPlanEntry entry)
        {
            var first = entry.AuditPlanProcesses?.FirstOrDefault(p => !p.IsDeleted);
            var name = (first?.ProcessName ?? first?.Office?.Name ?? "").Trim().ToLowerInvariant();
            return name.StartsWith("opening meeting") || name.StartsWith("closing meeting");
        }

        /// <summary>Returns how many schedules were added.</summary>
        public static async Task<int> EnsureForPlanAsync(DbContext db, int planId, CancellationToken ct)
        {
            var state = await IQAApprovalWorkflow.GetStateCodeAsync(
                db, IQAApprovalWorkflow.EntityTypes.AuditPlan, planId, ct);
            if (state != IQAApprovalWorkflow.StateCodes.Approved)
                return 0;

            var plan = await db.Set<AuditPlan>()
                .Include(p => p.Entries.Where(e => !e.IsDeleted))
                    .ThenInclude(e => e.AuditPlanProcesses.Where(ap => !ap.IsDeleted))
                        .ThenInclude(ap => ap.Office)
                .Include(p => p.Entries.Where(e => !e.IsDeleted))
                    .ThenInclude(e => e.IsoAuditors.Where(ia => !ia.IsDeleted))
                .AsSplitQuery()
                .FirstOrDefaultAsync(p => p.Id == planId && !p.IsDeleted, ct);
            if (plan == null)
                return 0;

            var existingEntryIds = await db.Set<AuditSchedule>()
                .Where(s => s.AuditPlanId == planId && s.IsActive)
                .Select(s => s.AuditPlanEntryId)
                .ToListAsync(ct);
            var taken = existingEntryIds.ToHashSet();

            // One group per office, in plan order (the same grouping the schedule page uses).
            var groups = new Dictionary<string, List<AuditPlanEntry>>();
            var order = new List<string>();
            foreach (var entry in plan.Entries.OrderBy(e => e.DayNumber).ThenBy(e => e.Time))
            {
                if (IsMeetingRow(entry)) continue;

                var process = entry.AuditPlanProcesses?.FirstOrDefault(p => !p.IsDeleted);
                var hasTeam = entry.IsoAuditors?.Any(a => !a.IsDeleted && a.TeamId != null) == true;

                // A typed line with no office and no team (e.g. "Reporting") is not an audit.
                if (process?.OfficeId == null && !hasTeam) continue;

                var key = (process?.Office?.Name ?? process?.ProcessName ?? "").Trim().ToLowerInvariant();
                if (key.Length == 0) continue;

                if (!groups.TryGetValue(key, out var list))
                {
                    list = new List<AuditPlanEntry>();
                    groups[key] = list;
                    order.Add(key);
                }
                list.Add(entry);
            }

            var added = 0;
            foreach (var key in order)
            {
                var entries = groups[key];
                if (entries.Any(e => taken.Contains(e.Id)))
                    continue;

                var first = entries[0];
                var officeId = entries
                    .Select(e => e.AuditPlanProcesses?.FirstOrDefault(p => !p.IsDeleted)?.OfficeId)
                    .FirstOrDefault(id => id != null);
                var teamId = entries
                    .SelectMany(e => e.IsoAuditors ?? Enumerable.Empty<IsoAuditor>())
                    .Where(a => !a.IsDeleted && a.TeamId != null)
                    .Select(a => a.TeamId)
                    .FirstOrDefault();

                var schedule = new AuditSchedule
                {
                    Id = 0,
                    Purpose = DefaultPurpose,
                    Activity = DefaultActivity,
                    IsActive = true,
                    StartDate = plan.StartDate,
                    EndDate = plan.EndDate,
                    AuditPlanId = plan.Id,
                    AuditPlanEntryId = first.Id,
                    TeamId = teamId,
                    AuditableOffices = new List<AuditableOffices>()
                };
                if (officeId != null)
                    schedule.AuditableOffices.Add(new AuditableOffices { Id = 0, AuditScheduleId = 0, OfficeId = officeId.Value });

                db.Set<AuditSchedule>().Add(schedule);
                added++;
            }

            return added;
        }
    }
}
