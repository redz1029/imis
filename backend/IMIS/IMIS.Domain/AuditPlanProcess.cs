using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditPlanProcess : Entity<int>
    {
        public required int OfficeId { get; set; }
        public Office? Office { get; set; }
        public required int AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; }

        
    }
}
