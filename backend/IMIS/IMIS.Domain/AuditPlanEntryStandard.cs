using Base.Primitives;

namespace IMIS.Domain
{
    /// <summary>
    /// Junction entity for many-to-many relationship between AuditPlanEntry and ISO Standards.
    /// Allows flexible linking of standards to audit plan entries.
    /// </summary>
    public class AuditPlanEntryStandard : Entity<long>
    {
        // Foreign key to AuditPlanEntry
        public required long AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; }
        
        // Foreign key to ISO Standard (reference entity ID)
        public required long StandardId { get; set; }
        public string? StandardCode { get; set; } // e.g., "ISO 9001:2015"
        public string? StandardName { get; set; } // e.g., "Quality Management Systems"
    }
}
