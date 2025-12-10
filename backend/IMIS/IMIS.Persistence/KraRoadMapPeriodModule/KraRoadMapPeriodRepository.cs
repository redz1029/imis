using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadMapPeriodModule
{
    public class KraRoadMapPeriodRepository : BaseRepository<KraRoadMapPeriod, int, ImisDbContext>, IKraRoadMapPeriodRepository
    {
        public KraRoadMapPeriodRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<EntityPageList<KraRoadMapPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<KraRoadMapPeriod, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<KraRoadMapPeriod?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadMapPeriod>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<IEnumerable<KraRoadMapPeriod>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
    }
}
