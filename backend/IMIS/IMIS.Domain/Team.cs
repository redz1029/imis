using Base.Primitives;

namespace IMIS.Domain
{
    public class Team : Entity<int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }
        public ICollection<AuditorTeams>? AuditorTeams { get; set; }
    }
}