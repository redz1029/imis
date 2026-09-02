using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.ServiceHeadOfficesModule
{
    public class ServiceHeadOfficesDto : BaseDto<ServiceHeadOffices, int>
    {
        public string? UserId { get; set; }
        public string? UserFullName { get; set; }
        public int? OfficeId { get; set; }
        public string? OfficeName { get; set; }

        public ServiceHeadOfficesDto() { }

        [SetsRequiredMembers]
        public ServiceHeadOfficesDto(ServiceHeadOffices entity)
        {
            this.Id = entity.Id;
            this.UserId = entity.UserId;
            this.UserFullName = BuildFullName(entity.User);
            this.OfficeId = entity.OfficeId;
            this.OfficeName = entity.Office?.Name;
        }

        private static string? BuildFullName(User? user)
        {
            if (user == null) return null;
            return string.Join(" ", new[]
            {
                user.Prefix,
                user.FirstName,
                user.MiddleName,
                user.LastName,
                user.Suffix
            }.Where(s => !string.IsNullOrWhiteSpace(s)));
        }

        public override ServiceHeadOffices ToEntity()
        {
            return new ServiceHeadOffices()
            {
                Id = Id,
                UserId = UserId,
                OfficeId = OfficeId,
            };
        }
    }
}
