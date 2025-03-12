using Base.Abstractions;
using IMIS.Application.UserOfficeModule;

namespace IMIS.Application.PGSReadinessRatingCancerCareModule
{
    public interface IPgsReadinessRatingService : IService
    {
        Task<List<PgsReadinessRatingDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PgsReadinessRatingDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<PgsReadinessRatingDto> SaveOrUpdateAsync(PgsReadinessRatingDto PGSReadiness, CancellationToken cancellationToken);
    }
}

