        using Base.Primitives;

namespace IMIS.Domain
{
    public class OfficeType : Entity<int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }
        public ICollection<Office>? Offices { get; set; }
    }
}
