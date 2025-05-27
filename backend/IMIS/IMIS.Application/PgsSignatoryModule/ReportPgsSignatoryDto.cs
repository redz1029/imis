using Base.Primitives;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Domain;

namespace IMIS.Application.PgsSignatoryModule
{
    public class ReportPgsSignatoryDto : BaseDto<PgsSignatory, long>
    {
        public required long PgsId { get; set; }
        public required int PgsSignatoryTemplateId { get; set; }
        public required string SignatoryId { get; set; }
        public DateTime DateSigned { get; set; }
        public PgsSignatoryTemplateDto? PgsSignatoryTemplate { get; set; }
        public User? User { get; set; }

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
