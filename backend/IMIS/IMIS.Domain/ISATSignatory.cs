using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class ISATSignatory : Entity<long>
    {
        public required long ISATId { get; set; }
        [ForeignKey("ISATId")]
        [InverseProperty("ISATSignatories")]
        public virtual ISAT? ISAT { get; set; }
        public int? ISATSignatoryTemplateId { get; set; }
        [ForeignKey("ISATSignatoryTemplateId")]
        public virtual ISATSignatoryTemplate? ISATSignatoryTemplate { get; set; }
        public required string SignatoryId { get; set; }
        [ForeignKey("SignatoryId")]
        public virtual User? Signatory { get; set; }
        public DateTime DateSigned { get; set; }
    }
}
