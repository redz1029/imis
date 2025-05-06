using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsSignatory : Entity<long>
    {
        public required long PgsId { get; set; }
        [ForeignKey("PgsId")]
        public virtual PerfomanceGovernanceSystem? PerfomanceGovernanceSystem { get; set; }
        public required int PgsSignatoryTemplateId { get; set; }
        [ForeignKey("PgsSignatoryTemplateId")]
        public virtual PgsSignatoryTemplate? PgsSignatoryTemplate { get; set; }
        public required string SignatoryId { get; set; }
        [ForeignKey("SignatoryId")]
        public virtual User? Signatory { get; set; }
        public DateTime DateSigned { get; set; }
    }
}
