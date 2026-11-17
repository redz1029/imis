using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.PolicyAndProcedureHistoryLogModule;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureDCRRFModule
{
    public class PolicyAndProcedureHistoryLogDCRRFDto : BaseDto<PolicyAndProcedureHistoryLog, long>
    {
     
        public List<PolicyAndProcedureHistoryLogListDto> PolicyAndProcedureLogList { get; set; } = new();

        public PolicyAndProcedureHistoryLogDCRRFDto() { }

        [SetsRequiredMembers]
        public PolicyAndProcedureHistoryLogDCRRFDto(PolicyAndProcedureHistoryLog entity)
        {
            Id = entity.Id;         
            PolicyAndProcedureLogList = entity.HistoryLogLists?
                .Where(x => !x.IsDeleted)
                .Select(x => new PolicyAndProcedureHistoryLogListDto(x))
                .ToList() ?? new();
        }

        public override PolicyAndProcedureHistoryLog ToEntity()
        {
            return new PolicyAndProcedureHistoryLog
            {
                Id = Id,               
            };
        }
    }
}
