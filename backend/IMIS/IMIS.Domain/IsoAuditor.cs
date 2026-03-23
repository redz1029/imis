using Base.Primitives;


namespace IMIS.Domain
{
    public class IsoAuditor : Entity<int>
    {
        public required int? TeamId { get; set; }
        public Team? Team { get; set; }

        public required string? AuditorId { get; set; }
        public Auditor? IsoAuditors { get; set; }

        public required int? AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; }
    }
}
