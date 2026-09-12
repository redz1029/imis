using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditChecklist : Entity<int>
    {
        // The two things a human actually fills in on the paper form.
        public bool? Conforming { get; set; }
        public string? FindingAndRemarks { get; set; }

        // Office/Process and Auditors (Team) are fetched through here —
        // never duplicated on this entity.
        public required int AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; }

        // Criteria/Clause and Items/Questions come from the library entry
        // linked here, not duplicated either.
        public required int AuditChecklistQNAId { get; set; }
        public AuditChecklistQNA? AuditChecklistQNA { get; set; }
    }
}