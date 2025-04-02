using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PGSReadinessRatingCancerCareModule
{
    public interface IPgsReadinessRatingService : IService
    {
        public Task<DtoPageList<PgsReadinessRatingDto, PgsReadinessRating, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<PgsReadinessRatingDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PgsReadinessRatingDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<PgsReadinessRatingDto> SaveOrUpdateAsync(PgsReadinessRatingDto pgsReadiness, CancellationToken cancellationToken);
    }
}

