using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolSignatoryModule
{
    public class PerformanceValidationToolSignatoryDto : BaseDto<PerformanceValidationToolSignatory, long>
    {
        public required long PerformanceValidationToolId { get; set; }
        public int? PerformanceValidationToolSignatoryTemplateId { get; set; }
        public required string SignatoryId { get; set; }
        public string? SignatoryName { get; set; }
        public DateTime DateSigned { get; set; }
        public string? Label { get; set; }
        public string? Status { get; set; }
        public int OrderLevel { get; set; }
        public bool IsNextStatus { get; set; }

        public override PerformanceValidationToolSignatory ToEntity()
        {
            return new PerformanceValidationToolSignatory()
            {
                Id = Id,
                PerformanceValidationToolId = PerformanceValidationToolId,
                PerformanceValidationToolSignatoryTemplateId = this.PerformanceValidationToolSignatoryTemplateId == 0 ? (int?)null : this.PerformanceValidationToolSignatoryTemplateId,
                SignatoryId = SignatoryId,
                DateSigned = DateSigned,
            };
        }
    }
}
