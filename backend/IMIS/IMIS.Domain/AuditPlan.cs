using Base.Primitives;

namespace IMIS.Domain
{
  
    public class AuditPlan : Entity<int>
    {
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }
        public required string PreparerId { get; set; } // IQA Lead Auditor
        public User? Preparer { get; set; }
        public required string SelectedApproverId { get; set; } // QMS Role
        public User? SelectedApprover { get; set; }
        public required string PlanStatus { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? LastModifiedDate { get; set; }

        // Navigation properties
        public ICollection<AuditPlanEntry>? Entries { get; set; }
        public ICollection<AuditPlanApproval>? Approvals { get; set; }
    }
}