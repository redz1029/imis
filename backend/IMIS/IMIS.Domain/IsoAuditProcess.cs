using Base.Primitives;

namespace IMIS.Domain
{
    public class IsoAuditProcess : Entity<int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }
        public required int AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; }
    }
}
