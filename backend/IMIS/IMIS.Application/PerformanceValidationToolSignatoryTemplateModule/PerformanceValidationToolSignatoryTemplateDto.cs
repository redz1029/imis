using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolSignatoryTemplateModule
{
    public class PerformanceValidationToolSignatoryTemplateDto : BaseDto<PerformanceValidationToolSignatoryTemplate, int>
    {
        public string? Status { get; set; }
        public string? SignatoryLabel { get; set; }
        public int OrderLevel { get; set; }
        public string? DefaultSignatoryId { get; set; }
        public bool IsActive { get; set; }
        public int OfficeId { get; set; }
        public string? Position { get; set; }
        public PerformanceValidationToolSignatoryTemplateDto() { }
        [SetsRequiredMembers]
        public PerformanceValidationToolSignatoryTemplateDto(PerformanceValidationToolSignatoryTemplate performanceValidationToolSignatoryTemplate)
        {
            this.Id = performanceValidationToolSignatoryTemplate.Id;
            this.Status = performanceValidationToolSignatoryTemplate.Status;
            this.SignatoryLabel = performanceValidationToolSignatoryTemplate.SignatoryLabel;
            this.OrderLevel = performanceValidationToolSignatoryTemplate.OrderLevel;
            this.DefaultSignatoryId = performanceValidationToolSignatoryTemplate.DefaultSignatoryId;
            this.IsActive = performanceValidationToolSignatoryTemplate.IsActive;
            this.OfficeId = performanceValidationToolSignatoryTemplate.OfficeId;
            this.Position = performanceValidationToolSignatoryTemplate.Position;
        }
        public override PerformanceValidationToolSignatoryTemplate ToEntity()
        {
            return new PerformanceValidationToolSignatoryTemplate()
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
