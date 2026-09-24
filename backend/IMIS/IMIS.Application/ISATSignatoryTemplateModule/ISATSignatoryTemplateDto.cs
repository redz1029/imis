using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.ISATSignatoryTemplateModule
{
    public class ISATSignatoryTemplateDto : BaseDto<ISATSignatoryTemplate, int>
    {
        public string? Status { get; set; }
        public string? SignatoryLabel { get; set; }
        public int OrderLevel { get; set; }
        public string? DefaultSignatoryId { get; set; }
        public bool IsActive { get; set; }
        public int OfficeId { get; set; }
        public string? Position { get; set; }
        public ISATSignatoryTemplateDto() { }
        [SetsRequiredMembers]
        public ISATSignatoryTemplateDto(ISATSignatoryTemplate ISATSignatoryTemplate)
        {
            this.Id = ISATSignatoryTemplate.Id;
            this.Status = ISATSignatoryTemplate.Status;
            this.SignatoryLabel = ISATSignatoryTemplate.SignatoryLabel;
            this.OrderLevel = ISATSignatoryTemplate.OrderLevel;
            this.DefaultSignatoryId = ISATSignatoryTemplate.DefaultSignatoryId;
            this.IsActive = ISATSignatoryTemplate.IsActive;
            this.OfficeId = ISATSignatoryTemplate.OfficeId;
            this.Position = ISATSignatoryTemplate.Position;
        }
        public override ISATSignatoryTemplate ToEntity()
        {
            return new ISATSignatoryTemplate()
            {
                Id = Id,
                Status = Status!,
                SignatoryLabel = SignatoryLabel!,
                OrderLevel = OrderLevel,
                DefaultSignatoryId = DefaultSignatoryId,
                IsActive = IsActive,
                OfficeId = OfficeId,
                Position = Position,
            };
        }
    }
}
