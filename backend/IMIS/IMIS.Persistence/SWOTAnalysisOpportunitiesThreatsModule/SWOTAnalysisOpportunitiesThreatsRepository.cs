using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.SWOTAnalysisOpportunitiesThreatsModule
{
    public class SWOTAnalysisOpportunitiesThreatsRepository : BaseRepository<SWOTAnalysisOpportunitiesThreats, int, ImisDbContext, User>, ISWOTAnalysisOpportunitiesThreatsRepository
    {
        public SWOTAnalysisOpportunitiesThreatsRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<SWOTAnalysisOpportunitiesThreats?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<SWOTAnalysisOpportunitiesThreats>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<SWOTAnalysisOpportunitiesThreats, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<SWOTAnalysisOpportunitiesThreats, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<IEnumerable<SWOTAnalysisOpportunitiesThreats>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
    }
}
