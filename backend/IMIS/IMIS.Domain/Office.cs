using Base.Primitives;

namespace IMIS.Domain
{
    public class Office : Entity<int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }
        public IEnumerable<AuditorOffices> AuditorOffices { get; set; }
    }
}
