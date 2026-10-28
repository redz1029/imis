using System;

namespace IMIS.Application.AuditScheduleModule
{
    /// <summary>
    /// Read model of a reschedule request. <see cref="CanDecide"/> tells the
    /// caller whether they are the approver the request is currently waiting on.
    /// </summary>
    public class AuditScheduleRescheduleRequestDto
    {
        public int Id { get; set; }
        public int AuditScheduleId { get; set; }
        public int AuditPlanId { get; set; }
        public string? OfficeName { get; set; }
        public DateTime CurrentStartDate { get; set; }
        public DateTime ProposedStartDate { get; set; }
        public string? Reason { get; set; }
        public string Status { get; set; } = string.Empty;
        public string? RequestedBy { get; set; }
        public DateTime RequestedDate { get; set; }
        public string? TeamLeaderRemarks { get; set; }
        public string? LeadAuditorRemarks { get; set; }
        public bool CanDecide { get; set; }
    }
}
