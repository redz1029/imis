namespace IMIS.Domain
{
    public class AuditorTeams
    {   
        public required int TeamId { get; set; }
        public Team? Team { get; set; }
        public required int AuditorId { get; set; }
        public Auditor? Auditor { get; set; }
        public bool IsTeamLeader { get; set; }
        public bool IsActive { get; set; }
    }
}








