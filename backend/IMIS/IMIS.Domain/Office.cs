using Base.Primitives;

namespace IMIS.Domain
{
    public class Office : Entity<int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }
        public ICollection<AuditorOffices>? AuditorOffices { get; set; }
        public ICollection<AuditableOffices>? AuditableOffices { get; set; }
        public ICollection<UserOffices>? UserOffices { get; set; }
    }
}
