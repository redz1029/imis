using Base.Primitives;

namespace IMIS.Domain
{
    public class Auditor : Entity<int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }
        public ICollection<AuditorOffices>? AuditorOffices { get; set; }
        public ICollection<AuditorTeams>? AuditorTeams { get; set; }
    }
}
