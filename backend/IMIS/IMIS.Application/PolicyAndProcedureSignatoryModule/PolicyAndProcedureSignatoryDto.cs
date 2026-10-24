using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureSignatoryModule
{
    public class PolicyAndProcedureSignatoryDto : BaseDto<PolicyAndProcedureSignatory, long>
    {
        public required long PAPId { get; set; }
        public int? PAPSignatoryTemplateId { get; set; }
        public required string SignatoryId { get; set; }
        public string? SignatoryName { get; set; }
        public DateTime DateSigned { get; set; }
        public string? Label { get; set; }
        public string? Status { get; set; }
        public int OrderLevel { get; set; }
        public bool IsNextStatus { get; set; }

        public PolicyAndProcedureSignatoryDto() { }

        [SetsRequiredMembers]
        public PolicyAndProcedureSignatoryDto(PolicyAndProcedureSignatory entity)
        {
            Id = entity.Id;
            PAPId = entity.PAPId;
            PAPSignatoryTemplateId = entity.PAPSignatoryTemplateId;
            SignatoryId = entity.SignatoryId;
            SignatoryName = FormatFullName(entity.Signatory);
            DateSigned = entity.DateSigned;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public static string? FormatFullName(User? user)
        {
            if (user == null)
                return null;

            return string.Join(" ", new[]
            {
                user.Prefix,
                user.FirstName,
                user.MiddleName,
                user.LastName,
                user.Suffix
            }.Where(x => !string.IsNullOrWhiteSpace(x)));
        }

        public override PolicyAndProcedureSignatory ToEntity()
        {
            return new PolicyAndProcedureSignatory()
            {
                Id = Id,
                PAPId = PAPId,
                PAPSignatoryTemplateId = this.PAPSignatoryTemplateId == 0 ? (int?)null : this.PAPSignatoryTemplateId,
                SignatoryId = SignatoryId,
                DateSigned = DateSigned,
            };
        }
    }
}
