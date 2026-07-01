using Base.Primitives;
using System;
using System.Collections.Generic;

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

        // Fix: Explicit Foreign Key pointing back to the parent Audit Programme
        public int AuditProgrammeId { get; set; }
        public AuditProgramme? AuditProgramme { get; set; }

        // Navigation properties
        // Fix: Initialize collections to avoid NullReferenceExceptions during mapping steps
        public ICollection<AuditPlanEntry> Entries { get; set; } = new List<AuditPlanEntry>();
        public ICollection<AuditPlanApproval> Approvals { get; set; } = new List<AuditPlanApproval>();
    }
}