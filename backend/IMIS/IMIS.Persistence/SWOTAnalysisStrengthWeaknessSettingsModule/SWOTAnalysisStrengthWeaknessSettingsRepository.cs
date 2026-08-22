using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.SWOTAnalysisStrengthWeaknessModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.SWOTAnalysisStrengthWeaknessModule
{
    public class SWOTAnalysisStrengthWeaknessRepository : BaseRepository<SWOTAnalysisStrengthWeakness, int, ImisDbContext, User>, ISWOTAnalysisStrengthWeaknessSettingsRepository
    {
        public SWOTAnalysisStrengthWeaknessRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<SWOTAnalysisStrengthWeakness?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<SWOTAnalysisStrengthWeakness>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<SWOTAnalysisStrengthWeakness, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<SWOTAnalysisStrengthWeakness, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<IEnumerable<SWOTAnalysisStrengthWeakness>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
    }
}

