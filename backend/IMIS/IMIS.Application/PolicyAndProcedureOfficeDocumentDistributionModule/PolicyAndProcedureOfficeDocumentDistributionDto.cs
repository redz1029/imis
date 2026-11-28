using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.PolicyAndProcedureOfficeDocumentDistributionListModule;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureOfficeDocumentDistributionModule
{
    public class PolicyAndProcedureOfficeDocumentDistributionDto : BaseDto<PolicyAndProcedureOfficeDocumentDistribution, long>
    {
        public long PolicyAndProcedureId { get; set; }
        public DateTime? PostingDate { get; set; }
        public bool? IsControlledCopy { get; set; }
        public bool? IsMasterCopy { get; set; }

        public List<PolicyAndProcedureOfficeDocumentDistributionListDto> OfficeDocumentDistributionList { get; set; } = new();

        public PolicyAndProcedureOfficeDocumentDistributionDto() { }

        [SetsRequiredMembers]
        public PolicyAndProcedureOfficeDocumentDistributionDto(PolicyAndProcedureOfficeDocumentDistribution entity)
        {
            Id = entity.Id;
            PolicyAndProcedureId = entity.PolicyAndProcedureId;
            PostingDate = entity.PostingDate;
            IsControlledCopy = entity.IsControlledCopy;
            IsMasterCopy = entity.IsMasterCopy;
            OfficeDocumentDistributionList = entity.OfficeDocumentDistributionList?
                .Where(x => !x.IsDeleted)
                .Select(x => new PolicyAndProcedureOfficeDocumentDistributionListDto(x))
                .ToList() ?? new();
        }

        public override PolicyAndProcedureOfficeDocumentDistribution ToEntity()
        {
            return new PolicyAndProcedureOfficeDocumentDistribution
            {
                Id = Id,
                PolicyAndProcedureId = PolicyAndProcedureId,
                PostingDate = PostingDate,
                IsControlledCopy = IsControlledCopy,
                IsMasterCopy = IsMasterCopy,
            };
        }
    }
}