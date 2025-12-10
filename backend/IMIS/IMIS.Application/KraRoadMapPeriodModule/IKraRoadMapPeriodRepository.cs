using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapPeriodModule
{
    public interface IKraRoadMapPeriodRepository : IRepository<KraRoadMapPeriod, int>
    {
        Task<IEnumerable<KraRoadMapPeriod>> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<KraRoadMapPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<KraRoadMapPeriod?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
