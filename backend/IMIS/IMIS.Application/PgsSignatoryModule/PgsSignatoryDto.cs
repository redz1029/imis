using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsSignatoryModule
{
    public class PgsSignatoryDto : BaseDto<PgsSignatory, long>
    {
        public required long PgsId { get; set; }    
        public int? PgsSignatoryTemplateId { get; set; }     
        public required string SignatoryId { get; set; }
        public string? SignatoryName { get; set; }
        public DateTime DateSigned { get; set; }
        public string? Label { get; set; }
        public string? Status { get; set; }
        public int OrderLevel { get; set; }
        public bool IsNextStatus { get; set; }
       
        public override PgsSignatory ToEntity()
        {
            return new PgsSignatory()
            {
                Id = Id,
                PgsId = PgsId,             
                PgsSignatoryTemplateId = this.PgsSignatoryTemplateId == 0 ? (int?)null : this.PgsSignatoryTemplateId,
                SignatoryId = SignatoryId,
                DateSigned = DateSigned,
                RowVersion = this.RowVersion

            };
        }
    }
}
