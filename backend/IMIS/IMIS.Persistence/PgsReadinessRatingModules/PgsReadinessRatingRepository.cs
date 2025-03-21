using Base.Abstractions;
using Base.Pagination;
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
        public async Task<EntityPageList<PgsReadinessRating, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _dbContext.PgsReadiness.Where(k => !k.IsDeleted).AsNoTracking();

            var pgsreadiness = await EntityPageList<PgsReadinessRating, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
            return pgsreadiness;
        }
        public async Task<IEnumerable<PgsReadinessRating>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.PgsReadiness
                .Where(o => !o.IsDeleted)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }        
        public new async Task<PgsReadinessRating> SaveOrUpdateAsync(PgsReadinessRating entity, CancellationToken cancellationToken)
        {
            var existingEntity = await _dbContext.Set<PgsReadinessRating>().FirstOrDefaultAsync(x => x.Id == entity.Id, cancellationToken);
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
