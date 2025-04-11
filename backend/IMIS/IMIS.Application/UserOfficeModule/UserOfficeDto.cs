using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Domain;

namespace IMIS.Application.UserOfficeModule
{
    public class UserOfficeDto : BaseDto<UserOffices, int>
    {       
        public required string UserId { get; set; }
        public required int OfficeId { get; set; }       
        public required bool IsActive { get; set; }


        // User-related fields
        public string? FirstName { get; set; }
        public string? MiddleName { get; set; }
        public string? LastName { get; set; }
        public string? Prefix { get; set; }
        public string? Suffix { get; set; }
        public string? Position { get; set; }

        public UserOfficeDto() { }
        [SetsRequiredMembers]
        public UserOfficeDto(UserOffices userOffices)
        {
            this.Id = userOffices.Id;
            this.UserId = userOffices.UserId;
            this.OfficeId = userOffices.OfficeId;
            this.IsActive = userOffices.IsActive;
        }
        public override UserOffices ToEntity()
        {
            return new UserOffices()
            {
                Id = Id,
                UserId = UserId,  
                OfficeId = OfficeId,                
                IsActive = IsActive
            };
        }
    }
}
