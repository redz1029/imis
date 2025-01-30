using Base.Primitives;

namespace IMIS.Domain
{
    public class Team : Entity<int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }
        public IEnumerable<AuditorTeams> AuditorTeams { get; set; }
    }
}
