using Base.Primitives;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Domain
{
    public class KraRoadMapRole : Entity<int>
    {
        public int? KraId { get; set; }
        public KeyResultArea? Kra { get; set; }
        public string? RoleId { get; set; }
        public IdentityRole? Role { get; set; }
    }
}
