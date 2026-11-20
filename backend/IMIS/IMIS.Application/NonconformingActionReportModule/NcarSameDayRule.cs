using System;
using System.Globalization;

namespace IMIS.Application.NonconformingActionReportModule
{
    /// <summary>
    /// The NCAR same-day rule, in one place so the notifications, the NCAR
    /// form and the status shown on it all say the same thing:
    ///
    ///  1. The auditor issues the NCAR on a day.
    ///  2. The audited office (auditee) must ACKNOWLEDGE it on that same day.
    ///  3. On that same day the auditee must also write the ROOT CAUSE ANALYSIS
    ///     and the PROPOSED ACTIONS.
    ///  4. On the day the auditee wrote them, the auditor must VERIFY what was
    ///     observed (the Department / Section Head approves the actions first).
    ///
    /// It is a deadline, not a lock: a late step is still accepted, but it is
    /// reported as overdue / late so nobody can miss it.
    /// Days are Philippine days (UTC+8, no daylight saving) because the server
    /// stores UTC and a day must start and end at midnight in Cotabato.
    /// </summary>
    public static class NcarSameDayRule
    {
        private static readonly TimeSpan Offset = TimeSpan.FromHours(8);

        public static class States
        {
            /// <summary>Nothing to measure yet (the step before it is not done).</summary>
            public const string NotYet = "NotYet";
            /// <summary>Done on or before its day.</summary>
            public const string Met = "Met";
            /// <summary>Done, but after its day.</summary>
            public const string Late = "Late";
            /// <summary>Not done yet and still today.</summary>
            public const string DueToday = "DueToday";
            /// <summary>Not done and its day has passed.</summary>
            public const string Overdue = "Overdue";
        }

        /// <summary>The Philippine calendar day (midnight) of a UTC moment.</summary>
        public static DateTime DayOf(DateTime utc) => (utc + Offset).Date;

        public static DateTime Today() => DayOf(DateTime.UtcNow);

        /// <summary>The day the office must acknowledge and answer by: the day the NCAR was issued.</summary>
        public static DateTime? ResponseDay(DateTime? issuedUtc) =>
            issuedUtc.HasValue ? DayOf(issuedUtc.Value) : null;

        /// <summary>The day the auditor must verify by: the day the office wrote its response.</summary>
        public static DateTime? VerificationDay(DateTime? proposedUtc) =>
            proposedUtc.HasValue ? DayOf(proposedUtc.Value) : null;

        /// <summary>How a step stands against its day.</summary>
        public static string StateOf(DateTime? dueDay, DateTime? doneUtc)
        {
            if (dueDay == null) return States.NotYet;
            if (doneUtc.HasValue)
                return DayOf(doneUtc.Value) <= dueDay.Value ? States.Met : States.Late;
            return Today() <= dueDay.Value ? States.DueToday : States.Overdue;
        }

        public static string Format(DateTime day) =>
            day.ToString("MMMM d, yyyy", CultureInfo.InvariantCulture);

        /// <summary>"today (November 20, 2026)" or "November 20, 2026 (overdue)".</summary>
        public static string When(DateTime day) =>
            day == Today() ? $"today ({Format(day)})" : $"{Format(day)} (overdue)";
    }
}
