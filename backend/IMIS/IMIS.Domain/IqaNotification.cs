using System;
using Base.Primitives;

namespace IMIS.Domain
{
    /// <summary>
    /// One notification for one person, raised by something that happened in
    /// IQA (a submission waiting for an approver, a decision, an NCAR step, ...).
    /// It is shown in the bell and opens the IQA page that holds the item.
    /// </summary>
    public class IqaNotification : Entity<long>
    {
        /// <summary>The user the notification is for.</summary>
        public required string RecipientUserId { get; set; }

        /// <summary>The user whose action raised it (never notified about their own action).</summary>
        public string? ActorUserId { get; set; }

        /// <summary>Short code of what happened, e.g. "Submitted", "Rejected", "NcarRaised".</summary>
        public required string Type { get; set; }

        public required string Title { get; set; }

        public required string Message { get; set; }

        /// <summary>"AuditProgramme", "AuditPlan", "AuditSchedule", "AuditChecklist", "AuditReport", "Ncar" or "RescheduleRequest".</summary>
        public required string EntityType { get; set; }

        public long? EntityId { get; set; }

        /// <summary>
        /// The ISO sub-page the item is on (the sidebar's sub-page index):
        /// 0 Programme, 1 Plan, 2 Schedules, 3 Checklist, 4 Report, 5 NCAR.
        /// </summary>
        public int TargetPage { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        /// <summary>Null while unread.</summary>
        public DateTime? ReadAt { get; set; }
    }
}
