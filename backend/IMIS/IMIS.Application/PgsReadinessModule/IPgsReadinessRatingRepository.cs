using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PGSReadinessRatingCancerCareModule
{
    public interface IPgsReadinessRatingRepository : IRepository<PgsReadinessRating, long>
    {       
        new Task<PgsReadinessRating> SaveOrUpdateAsync(PgsReadinessRating PGSReadiness, CancellationToken cancellationToken);
    }
}
