using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.KraRoadmapKpiSequenceModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadmapKpiSequenceModule
{
    public class KraRoadmapKpiSequenceRepository : BaseRepository<KraRoadmapKpiSequence, int, ImisDbContext, User>, IKraRoadmapKpiSequenceRepository
    {
        public KraRoadmapKpiSequenceRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<EntityPageList<KraRoadmapKpiSequence, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<KraRoadmapKpiSequence, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<KraRoadmapKpiSequence?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadmapKpiSequence>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<IEnumerable<KraRoadmapKpiSequence>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
    }
}
