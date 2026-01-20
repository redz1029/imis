using Base.Primitives;

namespace IMIS.Domain
{
    public enum AuditPlanStatus
    {
        Draft = 0,
        Pending = 1,
        Approved = 2
    }

    public class AuditPlanHeader : Entity<long>
    {
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }
        
        // IQA Lead Auditor (Preparer)
        public required long PreparerId { get; set; }
        public User? Preparer { get; set; }
        
        // QMS Role (Selected Approver)
        public long? ApproverId { get; set; }
        public User? Approver { get; set; }
        
        public required AuditPlanStatus Status { get; set; }
        
        // Navigation: One-to-many relationship with entries
        public List<AuditPlanEntry>? Entries { get; set; }
    }
}
