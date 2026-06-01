using Base.Primitives;


    namespace IMIS.Domain
    {
        public class AuditPlanStatus : Entity<int>
        {
            public required string Name { get; set; }
            public required bool IsActive { get; set; }
            public ICollection<AuditPlan>? AuditPlans { get; set; }
        }
    }

