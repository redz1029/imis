using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsSignatoryModule
{
    public class PgsSignatoryDto : BaseDto<PgsSignatory, long>
    {
        public required long PgsId { get; set; }    
        public required int PgsSignatoryTemplateId { get; set; }     
        public required string SignatoryId { get; set; }        
        public DateTime DateSigned { get; set; }

        public override PgsSignatory ToEntity()
        {
            return new PgsSignatory()
            {
                Id = Id,
                PgsId = PgsId,
                PgsSignatoryTemplateId = PgsSignatoryTemplateId,
                SignatoryId = SignatoryId,
                DateSigned = DateSigned
            };
        }
    }
}
