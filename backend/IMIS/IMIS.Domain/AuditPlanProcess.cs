using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditPlanProcess : Entity<int>
    {
        public int? OfficeId { get; set; }
        public Office? Office { get; set; }

        // New: stores the typed text when there's no matching Office row.
        public string? ProcessName { get; set; }

        public required int AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; } = null!;
    }
}