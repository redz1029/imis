using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureHistoryLogModule
{
    public class PolicyAndProcedureHistoryLogDto : BaseDto<PolicyAndProcedureHistoryLog, long>
    {
        public long PolicyAndProcedureId { get; set; }
        public string? TitleName { get; set; }
        public DateTime? Date { get; set; }
        public List<PolicyAndProcedureHistoryLogListDto> PolicyAndProcedureLogList { get; set; } = new();

        public PolicyAndProcedureHistoryLogDto() { }

        [SetsRequiredMembers]
        public PolicyAndProcedureHistoryLogDto(PolicyAndProcedureHistoryLog entity)
        {
            Id = entity.Id;
            PolicyAndProcedureId = entity.PolicyAndProcedureId;
            TitleName = entity.PolicyAndProcedure?.Title; 
            Date = entity.Date;
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
                PolicyAndProcedureId = PolicyAndProcedureId,
                Date = Date
            };
        }
    }
}