using Base.Primitives;
using System.Collections.Generic;

namespace IMIS.Domain
{
    /// <summary>
    /// Shared lookup for workflow status across the audit domain
    /// (Programme, Plan, Schedule). One table, one source of truth.
    /// </summary>
    public class AuditPlanStatus : Entity<int>
    {
        /// Stable machine key — never rename, UI/logic keys off this.
        public required string Code { get; set; }

        /// Human label shown in the UI (tabs, chips).
        public required string Name { get; set; }

        /// Tab/display order.
        public int SortOrder { get; set; }

        public bool IsActive { get; set; } = true;

        public ICollection<AuditProgramme> AuditProgrammes { get; set; } = new List<AuditProgramme>();
    }
}