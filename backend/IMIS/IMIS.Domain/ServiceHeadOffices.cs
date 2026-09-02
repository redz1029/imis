using Base.Primitives;

namespace IMIS.Domain
{
    public class ServiceHeadOffices : Entity<int>
    {
        public string? UserId { get; set; }
        public User? User { get; set; }
        public int? OfficeId { get; set; }
        public Office? Office { get; set; }
    }
}
