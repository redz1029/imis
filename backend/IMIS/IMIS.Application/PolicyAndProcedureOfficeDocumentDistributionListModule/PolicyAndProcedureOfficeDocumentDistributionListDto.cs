using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureOfficeDocumentDistributionListModule
{
    public class PolicyAndProcedureOfficeDocumentDistributionListDto : BaseDto<PolicyAndProcedureOfficeDocumentDistributionList, long>
    {

        public long PolicyAndProcedureOfficeDocumentDistributionId { get; set; }
        public string? CopyHolderUserId { get; set; }
        public int? OfficeId { get; set; }
        public DateTime? IssuanceDate { get; set; }
        public string? IssuanceRevision { get; set; }
        public DateTime? RetrievalDate { get; set; }
        public string? RetrievalRevision { get; set; }

        public PolicyAndProcedureOfficeDocumentDistributionListDto() { }

        [SetsRequiredMembers]
        public PolicyAndProcedureOfficeDocumentDistributionListDto(PolicyAndProcedureOfficeDocumentDistributionList entity)
        {
            Id = entity.Id;
            PolicyAndProcedureOfficeDocumentDistributionId = entity.PolicyAndProcedureOfficeDocumentDistributionId;
            CopyHolderUserId = entity.CopyHolderUserId;
            OfficeId = entity.OfficeId;
            IssuanceDate = entity.IssuanceDate;
            IssuanceRevision = entity.IssuanceRevision;
            RetrievalDate = entity.RetrievalDate;
            RetrievalRevision = entity.RetrievalRevision;
        }

        public override PolicyAndProcedureOfficeDocumentDistributionList ToEntity()
        {
            return new PolicyAndProcedureOfficeDocumentDistributionList
            {
                Id = Id,
                PolicyAndProcedureOfficeDocumentDistributionId = PolicyAndProcedureOfficeDocumentDistributionId,
                CopyHolderUserId = CopyHolderUserId,
                OfficeId = OfficeId,
                IssuanceDate = IssuanceDate,
                IssuanceRevision = IssuanceRevision,
                RetrievalDate = RetrievalDate,
                RetrievalRevision = RetrievalRevision
            };
        }
    }
}
