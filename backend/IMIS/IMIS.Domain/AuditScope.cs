using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditScope : Entity<int>
    {
        public AuditPlanProcess? AuditProcessAudited { get; set; }
        public AuditorTeams? AuditorTeams { get; set; }
        public required string Auditee { get; set; }

    }
}
