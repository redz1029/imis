using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.KraRoadMapModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadMapModule
{
    public class KraRoadMapRepository
        : BaseRepository<KraRoadMap, long, ImisDbContext>, IkraRoadMapRepository
    {
        public KraRoadMapRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<KraRoadMap?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadMap>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<KraRoadMap, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .AsNoTracking()
                .Include(x => x.Kra)
                .Include(x => x.KraRoadMapPeriod)
                .Include(x => x.Deliverables)
                .Include(x => x.Kpis);

            return await EntityPageList<KraRoadMap, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
        }

        public async Task<KraRoadMap?> GetByIdWithChildrenAsync(long id, CancellationToken cancellationToken = default)
        {
            return await _entities
            .Include(x => x.Kra)
            .Include(x => x.KraRoadMapPeriod)
            .Include(x => x.Deliverables)
            .Include(x => x.Kpis)
            .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
            .ConfigureAwait(false);
        }

        public async Task<IEnumerable<KraRoadMap>?> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .Include(x => x.Kra)
            .Include(x => x.KraRoadMapPeriod)
            .Include(x => x.Deliverables)
            .Include(x => x.Kpis)
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
    }
}
