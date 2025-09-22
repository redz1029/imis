using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsSignatoryTemplateModule
{
    public class PgsSignatoryTemplateDto : BaseDto<PgsSignatoryTemplate, int>
    {
        public string? Status { get; set; }
        public string? SignatoryLabel { get; set; }
        public int OrderLevel { get; set; }
        public string? DefaultSignatoryId { get; set; }
        public bool IsActive { get; set; }
        public int OfficeId { get; set; }
        public string? Position { get; set; }
        public PgsSignatoryTemplateDto() { }
        [SetsRequiredMembers]
        public PgsSignatoryTemplateDto(PgsSignatoryTemplate PgsSignatoryTemplate)
        {
            this.Id = PgsSignatoryTemplate.Id;
            this.Status = PgsSignatoryTemplate.Status;
            this.SignatoryLabel = PgsSignatoryTemplate.SignatoryLabel;
            this.OrderLevel = PgsSignatoryTemplate.OrderLevel;
            this.DefaultSignatoryId = PgsSignatoryTemplate.DefaultSignatoryId;
            this.IsActive = PgsSignatoryTemplate.IsActive;
            this.OfficeId = PgsSignatoryTemplate.OfficeId;
            this.Position = PgsSignatoryTemplate.Position;
        }
        public override PgsSignatoryTemplate ToEntity()
        {
            return new PgsSignatoryTemplate()
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
