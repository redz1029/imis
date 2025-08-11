using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PGSReadinessRatingCancerCareModule
{
    public interface IPgsReadinessRatingRepository : IRepository<PgsReadinessRating, long>
    {
        Task<EntityPageList<PgsReadinessRating, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<PgsReadinessRating>> GetAll(CancellationToken cancellationToken);      
    }
}
