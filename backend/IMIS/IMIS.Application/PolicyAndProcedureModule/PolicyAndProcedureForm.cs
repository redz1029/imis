using Microsoft.AspNetCore.Http;

namespace IMIS.Application.PolicyAndProcedureModule
{
    public class PolicyAndProcedureForm
    {
        public string? Title { get; set; }
        public string? ProcessOwner { get; set; }
        public string? RegulatoryStandard { get; set; }
        public DateTime EffectiveDate { get; set; }
        public int? SectionId { get; set; }
        public string? DocumentCode { get; set; }
        public string? Revision { get; set; }
        public string? Content { get; set; }
        public bool? IsMasterCopy { get; set; }
        public bool? IsControlledCopy { get; set; }
        public IFormFile? MinutesAttachmentPath { get; set; }
        public bool RemoveAttachment { get; set; }
    }
}
