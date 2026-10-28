using Base.Primitives;
using System;

namespace IMIS.Domain
{
    /// <summary>
    /// A Department Head's request to move an audit schedule. It is routed to the
    /// Auditor Team Leader first, then to the Lead Auditor. Only when the Lead
    /// Auditor accepts is the schedule revised (Audit Plan / Audit Programme).
    /// </summary>
    public class AuditScheduleRescheduleRequest : Entity<int>
    {
        public static class Statuses
        {
            public const string PendingTeamLeader = "Pending Team Leader";
            public const string PendingLeadAuditor = "Pending Lead Auditor";
            public const string Approved = "Approved";
            public const string RejectedByTeamLeader = "Rejected by Team Leader";
            public const string RejectedByLeadAuditor = "Rejected by Lead Auditor";
        }

        public int AuditScheduleId { get; set; }
        public AuditSchedule? AuditSchedule { get; set; }

        /// <summary>Requested new date and time of the audit.</summary>
        public DateTime ProposedStartDate { get; set; }

        public string? Reason { get; set; }
        public string Status { get; set; } = Statuses.PendingTeamLeader;

        public string? RequestedByUserId { get; set; }
        public DateTime RequestedDate { get; set; } = DateTime.UtcNow;

        public string? TeamLeaderUserId { get; set; }
        public DateTime? TeamLeaderDecisionDate { get; set; }
        public string? TeamLeaderRemarks { get; set; }

        public string? LeadAuditorUserId { get; set; }
        public DateTime? LeadAuditorDecisionDate { get; set; }
        public string? LeadAuditorRemarks { get; set; }
    }
}
