using Base.Abstractions;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PGSReadinessRatingCancerCareModule
{
    public class PgsReadinessRatingRepository : BaseRepository<PgsReadinessRating, long, ImisDbContext>, IPgsReadinessRatingRepository
    {
        public PgsReadinessRatingRepository(ImisDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<PgsReadinessRating>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.PgsReadiness
                .Where(o => !o.IsDeleted)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        // Implementing SaveOrUpdateAsync
        public async Task<PgsReadinessRating> SaveOrUpdateAsync(PgsReadinessRating entity, CancellationToken cancellationToken)
        {
            var existingEntity = await _dbContext.Set<PgsReadinessRating>()
                .FirstOrDefaultAsync(x => x.Id == entity.Id, cancellationToken);

            if (existingEntity == null)
            {
                // Insert new record
                await _dbContext.Set<PgsReadinessRating>().AddAsync(entity, cancellationToken);
            }
            else
            {
                // Update existing record
                existingEntity.CompetenceToDeliver = entity.CompetenceToDeliver;
                existingEntity.ResourceAvailability = entity.ResourceAvailability;
                existingEntity.ConfidenceToDeliver = entity.ConfidenceToDeliver;

                _dbContext.Set<PgsReadinessRating>().Update(existingEntity);
            }

            await _dbContext.SaveChangesAsync(cancellationToken);
            return entity;
        }       
    }
}
