using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PGSReadinessRatingCancerCareModule
{
    public interface IPGSReadinessRatingCancerCareRepository : IRepository<PGSReadinessRatingCancerCare, long>
    {       
        new Task<PGSReadinessRatingCancerCare> SaveOrUpdateAsync(PGSReadinessRatingCancerCare PGSReadiness, CancellationToken cancellationToken);
    }
}
