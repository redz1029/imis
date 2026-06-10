using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.StrategyReviewPeriodModule
{
    public interface IStrategyReviewPeriodRepository : IRepository<StrategyReviewPeriod, int>
    {
        Task<IEnumerable<StrategyReviewPeriod>> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<StrategyReviewPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<StrategyReviewPeriod?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
