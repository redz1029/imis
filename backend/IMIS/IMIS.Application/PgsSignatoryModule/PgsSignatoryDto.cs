using System.ComponentModel;
using System.Text.Json.Serialization;
using Base.Primitives;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Domain;

namespace IMIS.Application.PgsSignatoryModule
{
    public class PgsSignatoryDto : BaseDto<PgsSignatory, long>
    {
        public required long PgsId { get; set; }    
        public required int PgsSignatoryTemplateId { get; set; }     
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
                PgsSignatoryTemplateId = PgsSignatoryTemplateId,
                SignatoryId = SignatoryId,
                DateSigned = DateSigned,
                RowVersion = this.RowVersion

            };
        }
    }
}
