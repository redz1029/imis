using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditScheduleModule
{
    /// <summary>
    /// The times an audit can be moved to, as on the original Audit Plan form.
    /// Kept in one place so the list can be changed without touching the rules.
    /// </summary>
    public static class AuditSlotPolicy
    {
        /// <summary>Start times offered to the auditee (9:00, 10:00, 1:00 PM, 3:00 PM).</summary>
        public static readonly IReadOnlyList<TimeSpan> Slots = new[]
        {
            TimeSpan.FromHours(9),
            TimeSpan.FromHours(10),
            TimeSpan.FromHours(13),
            TimeSpan.FromHours(15)
        };

        /// <summary>How long one audit keeps its team and office busy.</summary>
        public const int AuditMinutes = 120;

        /// <summary>How long an opening / closing meeting keeps everybody busy.</summary>
        public const int MeetingMinutes = 60;

        public static bool IsSlot(TimeSpan time) =>
            Slots.Contains(new TimeSpan(time.Hours, time.Minutes, 0));

        public static string Label(DateTime start) =>
            start.ToString("h:mm tt", CultureInfo.InvariantCulture);
    }

    /// <summary>One free start time.</summary>
    public class AuditSlotDto
    {
        /// <summary>"HH:mm".</summary>
        public string Time { get; set; } = string.Empty;
        public DateTime Start { get; set; }
        /// <summary>"9:00 AM".</summary>
        public string Label { get; set; } = string.Empty;
        /// <summary>"Morning" or "Afternoon".</summary>
        public string Period { get; set; } = string.Empty;
    }

    /// <summary>The free start times of one day of the audit plan.</summary>
    public class AuditSlotDayDto
    {
        public DateTime Date { get; set; }
        public int DayNumber { get; set; }
        public List<AuditSlotDto> Slots { get; set; } = new();
    }

    /// <summary>
    /// What the Department Head may choose from when asking to move an audit:
    /// only the times the audit team (and the office) are free.
    /// </summary>
    public class AuditScheduleAvailabilityDto
    {
        public int AuditScheduleId { get; set; }
        public string? OfficeName { get; set; }
        public string? TeamName { get; set; }
        public DateTime CurrentStart { get; set; }
        public List<AuditSlotDayDto> Days { get; set; } = new();
        public bool HasFreeSlots { get; set; }
        /// <summary>Why nothing is offered, when nothing is.</summary>
        public string? Message { get; set; }
    }

    /// <summary>
    /// Works out when the audit team of one audit schedule is busy and when it is
    /// free. A team is busy while it has another audit, while one of its members
    /// is on another team's audit, during the plan's opening / closing meetings,
    /// and while another pending reschedule request holds that time for it. The
    /// audited office must be free as well. Reads only; saves nothing.
    /// </summary>
    public sealed class AuditScheduleAvailability
    {
        private sealed record Busy(DateTime Start, DateTime End, string Reason);

        private readonly List<Busy> _busy = new();

        private AuditScheduleAvailability(AuditSchedule schedule, AuditPlan plan, DateTime currentStart)
        {
            Schedule = schedule;
            Plan = plan;
            CurrentStart = currentStart;
        }

        public AuditSchedule Schedule { get; }
        public AuditPlan Plan { get; }

        /// <summary>When the audit is scheduled now (the plan entry's day and time).</summary>
        public DateTime CurrentStart { get; }

        public string? OfficeName { get; private set; }
        public string? TeamName { get; private set; }

        private static bool IsMeeting(string? name)
        {
            var n = (name ?? string.Empty).Trim().ToLowerInvariant();
            return n.StartsWith("opening meeting") || n.StartsWith("closing meeting");
        }

        private void Add(DateTime start, int minutes, string reason) =>
            _busy.Add(new Busy(start, start.AddMinutes(minutes), reason));

        public static async Task<AuditScheduleAvailability?> LoadAsync(
            DbContext db, int scheduleId, CancellationToken cancellationToken)
        {
            var schedule = await db.Set<AuditSchedule>()
                .Include(s => s.AuditableOffices!)
                    .ThenInclude(ao => ao.Office)
                .Include(s => s.AuditPlanEntry!)
                .Include(s => s.Team)
                .FirstOrDefaultAsync(s => s.Id == scheduleId && s.IsActive, cancellationToken)
                .ConfigureAwait(false);
            var entry = schedule?.AuditPlanEntry;
            if (schedule == null || entry == null) return null;

            var plan = await db.Set<AuditPlan>()
                .FirstOrDefaultAsync(p => p.Id == schedule.AuditPlanId, cancellationToken)
                .ConfigureAwait(false);
            if (plan == null) return null;

            // The plan entry is the source of the audit's day and time.
            var currentStart = plan.StartDate.Date.AddDays(entry.DayNumber - 1) + entry.Time.TimeOfDay;
            var result = new AuditScheduleAvailability(schedule, plan, currentStart);

            var activeOffices = schedule.AuditableOffices?.Where(a => !a.IsDeleted).ToList()
                ?? new List<AuditableOffices>();
            var officeIds = activeOffices.Select(a => a.OfficeId).ToHashSet();
            result.OfficeName = activeOffices.Select(a => a.Office?.Name).FirstOrDefault(n => !string.IsNullOrWhiteSpace(n));
            result.TeamName = schedule.Team?.Name;

            // The team(s) doing this audit.
            var ownTeams = (await db.Set<IsoAuditor>()
                    .Where(a => !a.IsDeleted && a.AuditPlanEntryId == entry.Id && a.TeamId != null)
                    .Select(a => a.TeamId!.Value)
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false))
                .ToHashSet();
            if (schedule.TeamId.HasValue) ownTeams.Add(schedule.TeamId.Value);

            // Their members, and every team that shares one of those members.
            var memberIds = new HashSet<int>();
            var sharedTeams = new HashSet<int>(ownTeams);
            if (ownTeams.Count > 0)
            {
                memberIds = (await db.Set<AuditorTeams>()
                        .Where(t => !t.IsDeleted && t.IsActive && ownTeams.Contains(t.TeamId) && t.AuditorId != null)
                        .Select(t => t.AuditorId!.Value)
                        .ToListAsync(cancellationToken)
                        .ConfigureAwait(false))
                    .ToHashSet();

                if (memberIds.Count > 0)
                {
                    var sharing = await db.Set<AuditorTeams>()
                        .Where(t => !t.IsDeleted && t.IsActive && t.AuditorId != null && memberIds.Contains(t.AuditorId.Value))
                        .Select(t => t.TeamId)
                        .ToListAsync(cancellationToken)
                        .ConfigureAwait(false);
                    foreach (var id in sharing) sharedTeams.Add(id);
                }
            }

            // Everything else on the plan(s) that cover these days.
            var from = plan.StartDate.Date;
            var to = plan.EndDate.Date;
            var others = await db.Set<AuditPlanEntry>()
                .Where(e => !e.IsDeleted && e.Id != entry.Id &&
                            e.AuditPlan != null && !e.AuditPlan.IsDeleted &&
                            e.AuditPlan.StartDate <= to && e.AuditPlan.EndDate >= from)
                .Select(e => new
                {
                    PlanStart = e.AuditPlan!.StartDate,
                    e.DayNumber,
                    e.Time,
                    Auditors = e.IsoAuditors!
                        .Where(a => !a.IsDeleted)
                        .Select(a => new { a.TeamId, a.AuditorId })
                        .ToList(),
                    Processes = e.AuditPlanProcesses!
                        .Where(p => !p.IsDeleted)
                        .Select(p => new
                        {
                            p.OfficeId,
                            p.ProcessName,
                            OfficeName = p.Office != null ? p.Office.Name : null
                        })
                        .ToList()
                })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            foreach (var e in others)
            {
                var start = e.PlanStart.Date.AddDays(e.DayNumber - 1) + e.Time.TimeOfDay;

                if (e.Processes.Any(p => IsMeeting(p.ProcessName ?? p.OfficeName)))
                {
                    result.Add(start, AuditSlotPolicy.MeetingMinutes,
                        "That time is taken by the opening / closing meeting.");
                    continue;
                }

                if (ownTeams.Count > 0 &&
                    e.Auditors.Any(a => a.TeamId.HasValue && ownTeams.Contains(a.TeamId.Value)))
                {
                    result.Add(start, AuditSlotPolicy.AuditMinutes,
                        "The audit team already has another audit at that time.");
                }
                else if (ownTeams.Count > 0 &&
                         e.Auditors.Any(a =>
                             (a.TeamId.HasValue && sharedTeams.Contains(a.TeamId.Value)) ||
                             (a.AuditorId.HasValue && memberIds.Contains(a.AuditorId.Value))))
                {
                    result.Add(start, AuditSlotPolicy.AuditMinutes,
                        "A member of the audit team is on another team's audit at that time.");
                }
                else if (e.Processes.Any(p => p.OfficeId.HasValue && officeIds.Contains(p.OfficeId.Value)))
                {
                    result.Add(start, AuditSlotPolicy.AuditMinutes,
                        "The office already has another audit at that time.");
                }
            }

            // A time another pending request is already asking for is held.
            var holds = await db.Set<AuditScheduleRescheduleRequest>()
                .Where(r => !r.IsDeleted && r.AuditScheduleId != scheduleId &&
                            (r.Status == AuditScheduleRescheduleRequest.Statuses.PendingTeamLeader ||
                             r.Status == AuditScheduleRescheduleRequest.Statuses.PendingLeadAuditor) &&
                            r.AuditSchedule != null && r.AuditSchedule.IsActive)
                .Select(r => new
                {
                    r.ProposedStartDate,
                    TeamId = r.AuditSchedule!.TeamId,
                    OfficeIds = r.AuditSchedule.AuditableOffices!
                        .Where(a => !a.IsDeleted)
                        .Select(a => a.OfficeId)
                        .ToList()
                })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            foreach (var h in holds)
            {
                if (ownTeams.Count > 0 && h.TeamId.HasValue && sharedTeams.Contains(h.TeamId.Value))
                    result.Add(h.ProposedStartDate, AuditSlotPolicy.AuditMinutes,
                        "Another reschedule request is already holding that time for the audit team.");
                else if (h.OfficeIds.Any(officeIds.Contains))
                    result.Add(h.ProposedStartDate, AuditSlotPolicy.AuditMinutes,
                        "Another reschedule request is already holding that time for the office.");
            }

            return result;
        }

        /// <summary>
        /// Why an audit starting at <paramref name="start"/> cannot happen (the
        /// team, one of its members or the office is busy), or null when it can.
        /// </summary>
        public string? ConflictFor(DateTime start)
        {
            var end = start.AddMinutes(AuditSlotPolicy.AuditMinutes);
            foreach (var b in _busy)
                if (start < b.End && b.Start < end)
                    return b.Reason;
            return null;
        }

        /// <summary>The free start times, day by day, from <paramref name="now"/> on.</summary>
        public AuditScheduleAvailabilityDto Build(DateTime now)
        {
            var dto = new AuditScheduleAvailabilityDto
            {
                AuditScheduleId = Schedule.Id,
                OfficeName = OfficeName,
                TeamName = TeamName,
                CurrentStart = CurrentStart
            };

            var first = Plan.StartDate.Date;
            var last = Plan.EndDate.Date;
            for (var day = first; day <= last && (day - first).Days < 366; day = day.AddDays(1))
            {
                var d = new AuditSlotDayDto { Date = day, DayNumber = (day - first).Days + 1 };
                foreach (var slot in AuditSlotPolicy.Slots)
                {
                    var start = day + slot;
                    if (start <= now || start == CurrentStart) continue;
                    if (ConflictFor(start) != null) continue;

                    d.Slots.Add(new AuditSlotDto
                    {
                        Time = $"{slot.Hours:00}:{slot.Minutes:00}",
                        Start = start,
                        Label = AuditSlotPolicy.Label(start),
                        Period = slot.Hours < 12 ? "Morning" : "Afternoon"
                    });
                }
                if (d.Slots.Count > 0) dto.Days.Add(d);
            }

            dto.HasFreeSlots = dto.Days.Count > 0;
            if (!dto.HasFreeSlots)
                dto.Message = "The audit team has no free time left in this audit plan. The current schedule stays.";
            return dto;
        }
    }
}
