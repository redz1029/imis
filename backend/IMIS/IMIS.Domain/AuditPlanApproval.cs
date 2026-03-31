using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditPlanApproval : Entity<int>
    {
        public required int AuditPlanId { get; set; }
        public AuditPlan? AuditPlan { get; set; }

        public required string ApproverId { get; set; }
        public User? Approver { get; set; }

        public required string Action { get; set; }
        public required DateTime Timestamp { get; set; }
        public string? Comments { get; set; }

    }
}