using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class PerformanceValidationToolSignatory : Entity<long>
    {
        public required long PerformanceValidationToolId { get; set; }
        public int? PerformanceValidationToolSignatoryTemplateId { get; set; }
        [ForeignKey("PerformanceValidationToolSignatoryTemplateId")]
        public virtual PerformanceValidationToolSignatoryTemplate? PerformanceValidationToolSignatoryTemplate { get; set; }
        public required string SignatoryId { get; set; }
        [ForeignKey("SignatoryId")]
        public virtual User? Signatory { get; set; }
        public DateTime DateSigned { get; set; }
    }
}
