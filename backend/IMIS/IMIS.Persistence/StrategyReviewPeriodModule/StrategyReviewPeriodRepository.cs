
using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.StrategyReviewPeriodModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.StrategyReviewPeriodModule
{
    public class StrategyReviewPeriodRepository : BaseRepository<StrategyReviewPeriod, int, ImisDbContext, User>, IStrategyReviewPeriodRepository
    {
        public StrategyReviewPeriodRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<StrategyReviewPeriod?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<StrategyReviewPeriod>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<StrategyReviewPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<StrategyReviewPeriod, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<IEnumerable<StrategyReviewPeriod>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
    }
}
