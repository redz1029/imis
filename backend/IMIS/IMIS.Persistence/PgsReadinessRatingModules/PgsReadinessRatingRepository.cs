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
            return await EntityPageList<PgsReadinessRating, long>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);           
        }
        public async Task<IEnumerable<PgsReadinessRating>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities               
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }                   
    }
}
