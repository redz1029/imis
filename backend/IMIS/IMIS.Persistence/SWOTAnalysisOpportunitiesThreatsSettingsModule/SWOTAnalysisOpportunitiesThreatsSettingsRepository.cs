using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.SWOTAnalysisOpportunitiesThreatsModule
{
    public class SWOTAnalysisOpportunitiesThreatsSettingsRepository : BaseRepository<SWOTAnalysisOpportunitiesThreatsSettings, int, ImisDbContext, User>, ISWOTAnalysisOpportunitiesThreatsSettingsRepository
    {
        public SWOTAnalysisOpportunitiesThreatsSettingsRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<SWOTAnalysisOpportunitiesThreatsSettings?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<SWOTAnalysisOpportunitiesThreatsSettings>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<SWOTAnalysisOpportunitiesThreatsSettings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<SWOTAnalysisOpportunitiesThreatsSettings, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<IEnumerable<SWOTAnalysisOpportunitiesThreatsSettings>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
    }
}
