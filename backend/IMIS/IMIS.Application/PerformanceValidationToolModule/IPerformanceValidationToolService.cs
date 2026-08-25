using Base.Abstractions;

namespace IMIS.Application.PerformanceValidationToolModule
{
    public interface IPerformanceValidationToolService : IService
    {
        Task<List<PerformanceValidationToolDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PerformanceValidationToolDto?> GetByIdAsync(long id, CancellationToken cancellationToken);      
        Task<List<PerformanceValidationToolDto>?> GetAllPgsIdTool(long? performanceGovernanceSystemId, CancellationToken cancellationToken);
        Task<PerformanceValidationToolDto> Submit(PerformanceValidationToolDto dto, string userId, CancellationToken cancellationToken);
        Task<PerformanceValidationToolDto?> GetByUserIdAndPerformanceValidationToolIdAsync(string userId, long performanceValidationToolId, CancellationToken cancellationToken);
        Task<ReportPerformanceValidationToolDto?> ReportGetByIdAsync(long id, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
