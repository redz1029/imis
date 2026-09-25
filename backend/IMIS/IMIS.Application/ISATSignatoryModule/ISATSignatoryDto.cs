using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.ISATSignatoryModule
{
    public class ISATSignatoryDto : BaseDto<ISATSignatory, long>
    {
        public required long ISATId { get; set; }
        public int? ISATSignatoryTemplateId { get; set; }
        public required string SignatoryId { get; set; }
        public string? SignatoryName { get; set; }
        public DateTime DateSigned { get; set; }
        public string? Label { get; set; }
        public string? Status { get; set; }
        public int OrderLevel { get; set; }
        public bool IsNextStatus { get; set; }

        public ISATSignatoryDto() { }

        [SetsRequiredMembers]
        public ISATSignatoryDto(ISATSignatory entity)
        {
            Id = entity.Id;
            ISATId = entity.ISATId;
            ISATSignatoryTemplateId = entity.ISATSignatoryTemplateId;
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

        public override ISATSignatory ToEntity()
        {
            return new ISATSignatory()
            {
                Id = Id,
                ISATId = ISATId,
                ISATSignatoryTemplateId = this.ISATSignatoryTemplateId == 0 ? (int?)null : this.ISATSignatoryTemplateId,
                SignatoryId = SignatoryId,
                DateSigned = DateSigned,
            };
        }
    }
}