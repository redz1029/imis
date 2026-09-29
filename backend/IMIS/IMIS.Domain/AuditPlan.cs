using Base.Primitives;
using System;
using System.Collections.Generic;
using System.Linq;

namespace IMIS.Domain
{
    public class AuditPlan : Entity<int>
    {
        //public enum AuditPlanStatus
        //{
        //    Approval = 1,
        //    PendingApproval = 2
        //}

        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }
        public required string PlanName { get; set; }
        public IsoAuditor? Preparer { get; set; }

        public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
        public DateTime? LastModifiedDate { get; set; }

        public int AuditProgrammeId { get; set; }
        public AuditProgramme? AuditProgramme { get; set; }

        public ICollection<AuditPlanEntry> Entries { get; set; } = new List<AuditPlanEntry>();

        // Fix: schedules that belong to this plan
        public ICollection<AuditSchedule> AuditSchedules { get; set; } = new List<AuditSchedule>();

        /// <summary>
        /// IQA Signatory records for this audit plan (approval workflow)
        /// </summary>
        public ICollection<IQASignatory> IQASignatories { get; set; } = new List<IQASignatory>();

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