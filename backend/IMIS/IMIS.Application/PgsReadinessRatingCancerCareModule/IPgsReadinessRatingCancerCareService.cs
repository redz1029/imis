using Base.Abstractions;


namespace IMIS.Application.PGSReadinessRatingCancerCareModule
{
    public interface IPgsReadinessRatingCancerCareService : IService
    {
        Task<PGSReadinessRatingCancerCareDto> SaveOrUpdateAsync(PGSReadinessRatingCancerCareDto PGSReadiness, CancellationToken cancellationToken);
    }
}

