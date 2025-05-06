using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsSignatoryTemplate : Entity<int>
    {
        public required string Status { get; set; }
        public required string SignatoryLabel { get; set; }
        public int OrderLevel { get; set; }
        public string? DefaultSignatoryId { get; set; }
        public User? DefaultSignatory { get; set; }
        public bool IsActive { get; set; }
    }
}
