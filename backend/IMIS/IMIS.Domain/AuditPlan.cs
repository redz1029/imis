using Base.Primitives;
using System;
using System.Collections.Generic;
using System.Linq;

namespace IMIS.Domain
{
    public class AuditPlan : Entity<int>
    {
        public enum AuditPlanStatus
        {
            Approval = 1,
            PendingApproval = 2
        }

        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }
        public IsoAuditor? Preparer { get; set; }

        public required string PlanStatus { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
        public DateTime? LastModifiedDate { get; set; }

        public int AuditProgrammeId { get; set; }
        public AuditProgramme? AuditProgramme { get; set; }

        public ICollection<AuditPlanEntry> Entries { get; set; } = new List<AuditPlanEntry>();
        public ICollection<AuditPlanApproval> Approvals { get; set; } = new List<AuditPlanApproval>();

        // Fix: schedules that belong to this plan
        public ICollection<AuditSchedule> AuditSchedules { get; set; } = new List<AuditSchedule>();

        // Fix: pushes this plan's date range onto every linked schedule.
        // Call this in the save flow before SaveChangesAsync.
        public void SyncScheduleDates()
        {
            foreach (var schedule in AuditSchedules)
            {
                schedule.StartDate = StartDate;
                schedule.EndDate = EndDate;
            }
        }
    }
}