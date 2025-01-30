namespace IMIS.Domain
{
    public class AuditorTeams
    {
        public int TeamId { get; set; }
        public Team Team { get; set; }

        public int AuditorId { get; set; }
        public Auditor Auditor { get; set; }

        public bool IsTeamLeader { get; set; }
        public bool IsActive { get; set; }
    }
}
