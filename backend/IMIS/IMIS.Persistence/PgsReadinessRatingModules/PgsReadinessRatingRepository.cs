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

            var pgsReadiness = await EntityPageList<PgsReadinessRating, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
            return pgsReadiness;
        }
        public async Task<IEnumerable<PgsReadinessRating>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.PgsReadiness
                .Where(o => !o.IsDeleted)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }        
        public new async Task<PgsReadinessRating> SaveOrUpdateAsync(PgsReadinessRating pgsReadinessRating, CancellationToken cancellationToken)
        {
            var existingPgsReadinessRating = await _dbContext.Set<PgsReadinessRating>().FirstOrDefaultAsync(x => x.Id == pgsReadinessRating.Id, cancellationToken);
            if (existingPgsReadinessRating == null)
            {
                // Insert new record
                await _dbContext.Set<PgsReadinessRating>().AddAsync(pgsReadinessRating, cancellationToken);
            }
            else
            {
                // Update existing record
                existingPgsReadinessRating.CompetenceToDeliver = pgsReadinessRating.CompetenceToDeliver;
                existingPgsReadinessRating.ResourceAvailability = pgsReadinessRating.ResourceAvailability;
                existingPgsReadinessRating.ConfidenceToDeliver = pgsReadinessRating.ConfidenceToDeliver;
                _dbContext.Set<PgsReadinessRating>().Update(existingPgsReadinessRating);
            }
            await _dbContext.SaveChangesAsync(cancellationToken);
            return pgsReadinessRating;
        }       
    }
}
