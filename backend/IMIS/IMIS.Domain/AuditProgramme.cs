using Base.Primitives;
using System.Collections.Generic;

namespace IMIS.Domain
{
    public class AuditProgramme : Entity<int>
    {
        public int Year { get; set; }
        public required string For { get; set; }
        public required string From { get; set; }
        public required string Purpose { get; set; }

        public ICollection<AuditProgrammeObjective> Objectives { get; set; } = new List<AuditProgrammeObjective>();

        public required string ScopeAndFreqAudit { get; set; }
        public required string InternalAuditSched { get; set; }
        public required string AuditPlanObjective { get; set; }
        public required string ScopeOfAudit { get; set; }


        // Fix: Changed 'Plan' to 'AuditPlans' to ensure consistency with the DTO mapping graph
        public ICollection<AuditPlan> AuditPlans { get; set; } = new List<AuditPlan>();
    }
}