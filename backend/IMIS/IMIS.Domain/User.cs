using Microsoft.AspNetCore.Identity;

namespace IMIS.Domain
{
    public class User : IdentityUser
    {
        public string? FirstName { get; set; } 
        public string? MiddleName { get; set; }
        public string? LastName { get; set; }
        public string? Prefix { get; set; }
        public string? Suffix { get; set; }
        public string? Position {  get; set; }         
    }
}
