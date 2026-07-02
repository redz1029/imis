using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolModule
{
    public interface IPerformanceValidationToolRepository : IRepository<PerformanceValidationTool, long>
    {
        Task<IEnumerable<PerformanceValidationTool>> GetAll(CancellationToken cancellationToken);
        Task<IEnumerable<PerformanceValidationTool>?> GetAllPgsIdTool(long? performanceGovernanceSystemId, CancellationToken cancellationToken);
        Task<PerformanceValidationTool?> GetByPvtIdAsync(long id, CancellationToken cancellationToken);
        Task<PerformanceValidationTool?> GetWithIncludesAsync(long id, CancellationToken cancellationToken);
        Task<PerformanceValidationTool?> GetByUserIdAndPerformanceValidationToolIdAsync(long performanceValidationToolId, CancellationToken cancellationToken);
    }
}
