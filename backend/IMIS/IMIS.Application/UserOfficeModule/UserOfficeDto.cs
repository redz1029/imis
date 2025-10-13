using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.UserOfficeModule
{
    public class UserOfficeDto : BaseDto<UserOffices, int>
    {       
        public required string UserId { get; set; }
        public required int OfficeId { get; set; }       
        public required bool IsActive { get; set; }     
        public string? FirstName { get; set; }
        public string? MiddleName { get; set; }
        public string? LastName { get; set; }
        public string? Prefix { get; set; }
        public string? Suffix { get; set; }
        public string? Position { get; set; }
        public bool IsOfficeHead { get; set; }

        public UserOfficeDto() { }
        [SetsRequiredMembers]      
        public UserOfficeDto(UserOffices userOffices, List<User>? users = null)
        {
           
            this.Id = userOffices.Id;
            this.UserId = userOffices.UserId;
            this.OfficeId = userOffices.OfficeId;
            this.IsActive = userOffices.IsActive;
            this.IsOfficeHead = userOffices.IsOfficeHead;

            if (users != null)
            {
                var user = users.FirstOrDefault(u => u.Id == userOffices.UserId);
                if (user != null)
                {
                    this.FirstName = user.FirstName;
                    this.MiddleName = user.MiddleName;
                    this.LastName = user.LastName;
                    this.Prefix = user.Prefix;
                    this.Suffix = user.Suffix;
                    this.Position = user.Position;
                }
            }
        }

        public override UserOffices ToEntity()
        {
            return new UserOffices()
            {
                Id = Id,
                UserId = UserId,  
                OfficeId = OfficeId,                
                IsActive = IsActive,
                IsOfficeHead = IsOfficeHead
            };
        }
    }
}
