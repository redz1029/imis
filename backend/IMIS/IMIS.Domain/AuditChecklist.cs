using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditChecklist : Entity<int>
    {
        // The two things a human actually fills in on the paper form.
        public bool? Conforming { get; set; }
        public string? FindingAndRemarks { get; set; }

        /// <summary>
        /// What a "N" answer is: <see cref="NonconformityType"/> (NC) or
        /// <see cref="OpportunityType"/> (OFI). Null while the row is not "N".
        /// A "N" row saved before this existed has none and counts as NC.
        /// The audit report fetches its Summary of Findings line from it.
        /// </summary>
        public string? FindingType { get; set; }

        public const string NonconformityType = "NC";
        public const string OpportunityType = "OFI";

        /// <summary>The finding type a row may hold: NC or OFI only when it is answered "N", otherwise none.</summary>
        public static string? NormalizeFindingType(bool? conforming, string? findingType)
        {
            if (conforming != false) return null;
            return string.Equals(findingType?.Trim(), OpportunityType, System.StringComparison.OrdinalIgnoreCase)
                ? OpportunityType
                : NonconformityType;
        }

        // AUDITEE/S is a STRING on the CRMC form header (e.g.
        // "Chief of Hospital, Medical Records Officer, Section Head").
        // Deliberately NOT modeled as an entity/navigation — the checklist
        // only needs the auditee text. The existing AuditeeId link below is
        // kept for backwards compatibility with legacy single-auditee data.
        public string? Auditees { get; set; }

        // Office/Process and Auditors (Team) are fetched through here —
        // never duplicated on this entity.
        public required int AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; }

        public required int AuditScheduleId { get; set; }
        public AuditSchedule? AuditSchedule { get; set; }
        // Criteria/Clause and Items/Questions come from the library entry
        // linked here, not duplicated either.
        public required int AuditChecklistQNAId { get; set; }
        public AuditChecklistQNA? AuditChecklistQNA { get; set; }
        public int? AuditeeId { get; set; }
        public Auditee? Auditee { get; set; }
    }
}