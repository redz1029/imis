using Base.Abstractions;

namespace IMIS.Application.PolicyAndProcedureHistoryLogModule
{
    public interface IPolicyAndProcedureHistoryLogService : IService
    {
        Task<PolicyAndProcedureHistoryLogDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<PolicyAndProcedureHistoryLogDto> SaveOrUpdateAsync(PolicyAndProcedureHistoryLogDto dto, CancellationToken cancellationToken);
    }
}
