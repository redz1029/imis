using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureHistoryLogModule
{
    public class PolicyAndProcedureHistoryLogListDto : BaseDto<PolicyAndProcedureHistoryLogList, long>
    {
        public long PolicyAndProcedureHistoryLogId { get; set; }
        public string? DocumentCode { get; set; }
        public string? PageNo { get; set; }
        public string? Revision { get; set; }
        public DateTime? Date { get; set; }
        public string? Reasons { get; set; }

        public PolicyAndProcedureHistoryLogListDto() { }

        [SetsRequiredMembers]
        public PolicyAndProcedureHistoryLogListDto(PolicyAndProcedureHistoryLogList entity)
        {
            Id = entity.Id;
            PolicyAndProcedureHistoryLogId = entity.PolicyAndProcedureHistoryLogId;
            DocumentCode = entity.DocumentCode;
            PageNo = entity.PageNo;
            Revision = entity.Revision;
            Date = entity.Date;
            Reasons = entity.Reasons;
        }

        public override PolicyAndProcedureHistoryLogList ToEntity()
        {
            return new PolicyAndProcedureHistoryLogList
            {
                Id = Id,
                PolicyAndProcedureHistoryLogId = PolicyAndProcedureHistoryLogId,
                DocumentCode = DocumentCode,
                PageNo = PageNo,
                Revision = Revision,
                Date = Date,
                Reasons = Reasons
            };
        }
    }
}