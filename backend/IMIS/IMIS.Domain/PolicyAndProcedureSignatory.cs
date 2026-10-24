using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class PolicyAndProcedureSignatory : Entity<long>
    {
        public required long PAPId { get; set; }
        [ForeignKey("PAPId")]
        [InverseProperty("PAPSignatories")]
        public virtual PolicyAndProcedure? PAP { get; set; }
        public int? PAPSignatoryTemplateId { get; set; }
        [ForeignKey("PAPSignatoryTemplateId")]
        public virtual PolicyAndProcedureSignatoryTemplate? PAPSignatoryTemplate { get; set; }
        public required string SignatoryId { get; set; }
        [ForeignKey("SignatoryId")]
        public virtual User? Signatory { get; set; }
        public DateTime DateSigned { get; set; }
    }
}
