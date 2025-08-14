using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditorTeams : Entity<int>
    {   
        public required int TeamId { get; set; }
        public Team? Team { get; set; }
        public int? AuditorId { get; set; }
        public Auditor? Auditor { get; set; }
        public bool IsTeamLeader { get; set; }
        public bool IsActive { get; set; }
    }
}








