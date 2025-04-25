namespace IMIS.Presentation.UserModule
{
    public class UserRegistrationDto
    {
        public string? Id { get; set; }
        public required string Username { get; set; }
        public required string Email { get; set; } 
        public required string Password { get; set; }           
        public required string FirstName { get; set; }
        public string? MiddleName { get; set; }
        public required string LastName { get; set; }
        public string? Prefix { get; set; }
        public string? Suffix { get; set; }
        public string? Position { get; set; }

    }
}
