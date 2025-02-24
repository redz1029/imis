using Base.Abstractions;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PGSReadinessRatingCancerCareModule
{
    public class PGSReadinessRatingCancerCareRepository : BaseRepository<PGSReadinessRatingCancerCare, long, ImisDbContext>, IPGSReadinessRatingCancerCareRepository
    {
        public PGSReadinessRatingCancerCareRepository(ImisDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<PGSReadinessRatingCancerCare>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.PgsReadiness
                .Where(o => !o.IsDeleted)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        // Implementing SaveOrUpdateAsync
        public async Task<PGSReadinessRatingCancerCare> SaveOrUpdateAsync(PGSReadinessRatingCancerCare entity, CancellationToken cancellationToken)
        {
            var existingEntity = await _dbContext.Set<PGSReadinessRatingCancerCare>()
                .FirstOrDefaultAsync(x => x.Id == entity.Id, cancellationToken);

            if (existingEntity == null)
            {
                // Insert new record
                await _dbContext.Set<PGSReadinessRatingCancerCare>().AddAsync(entity, cancellationToken);
            }
            else
            {
                // Update existing record
                existingEntity.Score1 = entity.Score1;
                existingEntity.Score2 = entity.Score2;
                existingEntity.Score3 = entity.Score3;

                _dbContext.Set<PGSReadinessRatingCancerCare>().Update(existingEntity);
            }

            await _dbContext.SaveChangesAsync(cancellationToken);
            return entity;
        }       
    }
}
