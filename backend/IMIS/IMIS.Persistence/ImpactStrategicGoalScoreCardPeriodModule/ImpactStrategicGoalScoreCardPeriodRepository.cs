using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.ImpactStrategicGoalScoreCardPeriodModule
{
    public class ImpactStrategicGoalScoreCardPeriodRepository : BaseRepository<ImpactStrategicGoalScoreCardPeriod, int, ImisDbContext, User>, IImpactStrategicGoalScoreCardPeriodRepository
    {
        public ImpactStrategicGoalScoreCardPeriodRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<EntityPageList<ImpactStrategicGoalScoreCardPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<ImpactStrategicGoalScoreCardPeriod, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<ImpactStrategicGoalScoreCardPeriod?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<ImpactStrategicGoalScoreCardPeriod>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<ImpactStrategicGoalScoreCardPeriod>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
    }
}
