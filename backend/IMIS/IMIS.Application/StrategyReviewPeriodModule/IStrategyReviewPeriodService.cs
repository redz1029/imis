using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.StrategyReviewPeriodModule
{
    public interface IStrategyReviewPeriodService : IService
    {
        Task<List<StrategyReviewPeriodDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<StrategyReviewPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<StrategyReviewPeriodDto, StrategyReviewPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
