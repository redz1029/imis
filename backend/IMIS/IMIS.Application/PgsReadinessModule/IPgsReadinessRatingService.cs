using Base.Abstractions;


namespace IMIS.Application.PGSReadinessRatingCancerCareModule
{
    public interface IPgsReadinessRatingService : IService
    {
        Task<PgsReadinessRatingDto> SaveOrUpdateAsync(PgsReadinessRatingDto PGSReadiness, CancellationToken cancellationToken);
    }
}

