using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Application.PerformanceValidationToolPeriodModule
{
    public interface IPerformanceValidationToolPeriodService : IService
    {
        Task<List<PerformanceValidationToolPeriodDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PerformanceValidationToolPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<PerformanceValidationToolPeriodDto, PerformanceValidationToolPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
