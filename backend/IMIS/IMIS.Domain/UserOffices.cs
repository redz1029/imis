using Base.Primitives;

namespace IMIS.Domain
{
    public class UserOffices : Entity<int>
    {     
        public required string UserId { get; set; }
        public required int OfficeId { get; set; }       
        public required bool IsActive { get; set; }
        public bool IsOfficeHead { get; set; }
    }
}


