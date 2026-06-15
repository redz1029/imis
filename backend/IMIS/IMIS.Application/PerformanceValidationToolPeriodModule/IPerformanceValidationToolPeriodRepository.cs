using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolPeriodModule
{
    public interface IPerformanceValidationToolPeriodRepository : IRepository<PerformanceValidationToolPeriod, int>
    {
        Task<EntityPageList<PerformanceValidationToolPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<PerformanceValidationToolPeriod>> GetAll(CancellationToken cancellationToken);
        Task<PerformanceValidationToolPeriod?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);

    }
}
