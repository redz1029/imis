using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureHistoryLogModule
{
    public interface IPolicyAndProcedureHistoryLogRepository : IRepository<PolicyAndProcedureHistoryLog, long>
    {
        Task<PolicyAndProcedureHistoryLog?> GetByIdWithListAsync(long id, CancellationToken cancellationToken);
    }
}
