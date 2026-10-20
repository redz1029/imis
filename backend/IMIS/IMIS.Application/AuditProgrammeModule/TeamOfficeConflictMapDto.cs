namespace IMIS.Application.AuditProgrammeModule
{
    /// <summary>
    /// A single team's "home offices": every OfficeId that at least one member
    /// of the team belongs to (AuditorTeams -> AuditorOffices). The Audit
    /// Programme screen uses this map to detect self-audit inline, without a
    /// round trip per keystroke.
    /// </summary>
    public class TeamOfficeConflictMapDto
    {
        /// <summary>TeamId -> set of OfficeIds its members belong to.</summary>
        public Dictionary<int, List<int>> TeamOfficeIds { get; set; } = new();

        /// <summary>OfficeId -> office name (for readable messages).</summary>
        public Dictionary<int, string> OfficeNames { get; set; } = new();

        /// <summary>TeamId -> team name (for the "Members of [Team]" message).</summary>
        public Dictionary<int, string> TeamNames { get; set; } = new();
    }
}
