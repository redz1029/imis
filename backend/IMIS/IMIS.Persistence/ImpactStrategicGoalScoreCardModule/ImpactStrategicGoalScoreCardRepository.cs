using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.ImpactStrategicGoalScoreCardModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.ImpactStrategicGoalScoreCardModule
{
    public class ImpactStrategicGoalScoreCardRepository : BaseRepository<ImpactStrategicGoalScoreCard, long, ImisDbContext, User>, IImpactStrategicGoalScoreCardRepository
    {
        public ImpactStrategicGoalScoreCardRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<EntityPageList<ImpactStrategicGoalScoreCard, long>> GetPaginatedAsync(long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
            .AsNoTracking()
            .Include(x => x.ImpactStrategicGoalScoreCardPeriod)
            .AsNoTracking();

            if (pgsPeriodId.HasValue)
            {
                query = query.Where(p => p.ImpactStrategicGoalScoreCardPeriod!.Id == pgsPeriodId.Value);
            }
            var paginatedResult = await EntityPageList<ImpactStrategicGoalScoreCard, long>
            .CreateAsync(query, page, pageSize, cancellationToken)
            .ConfigureAwait(false);
            return paginatedResult;

        }
       
        public async Task<ImpactStrategicGoalScoreCard?> GetByIdWithChildrenAsync(long id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<ImpactStrategicGoalScoreCard>()
            .Include(x => x.ImpactStrategicGoalScoreCardPeriod)
            .Include(x => x.ImpactScoreCard)
                .ThenInclude(sc => sc!.ImpactScoreCardIndicator)
                    .ThenInclude(ind => ind!.ImpactScoreCardTarget)
            .Include(x => x.ImpactStrategicScoreCard)
                .ThenInclude(ssc => ssc!.ImpactStrategicScoreCardMeasure)
                    .ThenInclude(m => m!.ImpactStrategicScoreCardTarget)
            .AsSplitQuery()
            .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);
        }
    }
}
