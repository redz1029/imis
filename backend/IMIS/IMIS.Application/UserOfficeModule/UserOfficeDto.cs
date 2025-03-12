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
