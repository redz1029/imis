using Base.Primitives;
using System;

namespace IMIS.Domain
{
    /// <summary>
    /// The Auditor Team Leader hands one clause of the audit plan entry (and every
    /// checklist question under it) to one auditor of the team. The auditor then
    /// only sees and answers the checklist rows of the clauses assigned to them.
    /// </summary>
    public class AuditChecklistClauseAssignment : Entity<int>
    {
        public int AuditScheduleId { get; set; }
        public AuditSchedule? AuditSchedule { get; set; }

        /// <summary>A clause selected on the audit plan entry (IsoStandardAuditPlan).</summary>
        public long IsoStandardId { get; set; }
        public IsoStandard? IsoStandard { get; set; }

        public int AuditorId { get; set; }
        public Auditor? Auditor { get; set; }

        public string? AssignedByUserId { get; set; }
        public DateTime AssignedDate { get; set; } = DateTime.UtcNow;
    }
}
