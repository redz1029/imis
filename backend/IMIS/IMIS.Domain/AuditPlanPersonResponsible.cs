using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditPlanPersonResponsible : Entity<int>
    {
        public required string Name { get; set; }

        public required int AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; }

    }
}