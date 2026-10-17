using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.UserModule
{
    public class UserDto
    {
        public string? Id { get; set; }
        public string? UserName { get; set; }
        public string? Email { get; set; }
        public string? FirstName { get; set; }
        public string? MiddleName { get; set; }
        public string? LastName { get; set; }
        public string? Position { get; set; }
        public string? FullName => $"{FirstName} {MiddleName} {LastName}".Replace("  ", " ").Trim();

        public UserDto() { }

        [SetsRequiredMembers]
        public UserDto(IMIS.Domain.User user)
        {
            if (user != null)
            {
                Id = user.Id;
                UserName = user.UserName;
                Email = user.Email;
                FirstName = user.FirstName;
                MiddleName = user.MiddleName;
                LastName = user.LastName;
                Position = user.Position;
            }
        }
    }
}