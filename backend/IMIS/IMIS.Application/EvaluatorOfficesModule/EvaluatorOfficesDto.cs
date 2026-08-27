using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;
namespace IMIS.Application.EvaluatorOfficesModule
{
    public class EvaluatorOfficesDto : BaseDto<EvaluatorOffices, int>
    {
        public string? UserId { get; set; }
        public string? UserFullName { get; set; }
        public int? OfficeId { get; set; }
        public string? OfficeName { get; set; }

        public EvaluatorOfficesDto() { }

        [SetsRequiredMembers]
        public EvaluatorOfficesDto(EvaluatorOffices entity)
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

        public override EvaluatorOffices ToEntity()
        {
            return new EvaluatorOffices()
            {
                Id = Id,
                UserId = UserId,
                OfficeId = OfficeId,
            };
        }
    }
}
