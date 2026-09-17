using Base.Primitives;

namespace IMIS.Domain
{
    public class Auditee : Entity<int>
    {
        public required string Name { get; set; }

        public required string UserId { get; set; }
        public User? User { get; set; }
    }
}