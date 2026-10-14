using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureModule
{
    public class PolicyAndProcedureDto : BaseDto<PolicyAndProcedure, long>
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
        public string? MinutesAttachmentPath { get; set; }

        public PolicyAndProcedureDto() { }

        [SetsRequiredMembers]
        public PolicyAndProcedureDto(PolicyAndProcedure policyAndProcedure)
        {
            this.Id = policyAndProcedure.Id;
            this.Title = policyAndProcedure.Title;
            this.ProcessOwner = policyAndProcedure.ProcessOwner;
            this.RegulatoryStandard = policyAndProcedure.RegulatoryStandard;
            this.EffectiveDate = policyAndProcedure.EffectiveDate;
            this.SectionId = policyAndProcedure.SectionId;
            this.DocumentCode = policyAndProcedure.DocumentCode;
            this.Revision = policyAndProcedure.Revision;
            this.Content = policyAndProcedure.Content;         
            this.IsMasterCopy = policyAndProcedure.IsMasterCopy;
            this.IsControlledCopy = policyAndProcedure.IsControlledCopy;
            this.MinutesAttachmentPath = policyAndProcedure.MinutesAttachmentPath;          
        }
     
        public override PolicyAndProcedure ToEntity()
        {
            return new PolicyAndProcedure()
            {
                Id = Id,
                Title = Title,
                ProcessOwner = ProcessOwner,
                RegulatoryStandard = RegulatoryStandard,
                EffectiveDate = EffectiveDate,
                SectionId = SectionId,
                DocumentCode = DocumentCode,
                Revision = Revision,
                Content = Content,
                IsMasterCopy = IsMasterCopy,
                IsControlledCopy = IsControlledCopy,            
                MinutesAttachmentPath = MinutesAttachmentPath,            
            };
        }
    }
}
