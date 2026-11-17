using Base.Abstractions;
using IMIS.Application.PolicyAndProcedureDCRRFModule;

namespace IMIS.Application.PolicyAndProcedureHistoryLogModule
{
    public interface IPolicyAndProcedureHistoryLogService : IService
    {
        Task<PolicyAndProcedureHistoryLogDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<PolicyAndProcedureHistoryLogDCRRFDto?> GetByIdDCRRFAsync(long id, CancellationToken cancellationToken);
        Task<PolicyAndProcedureHistoryLogDto> SaveOrUpdateAsync(PolicyAndProcedureHistoryLogDto dto, CancellationToken cancellationToken);
    }
}
