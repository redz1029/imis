using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.SWOTAnalysisStrengthWeaknessModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.SWOTAnalysisStrengthWeaknessModule
{
    public class SWOTAnalysisStrengthWeaknessSettingsRepository : BaseRepository<SWOTAnalysisStrengthWeaknessSettings, int, ImisDbContext, User>, ISWOTAnalysisStrengthWeaknessSettingsRepository
    {
        public SWOTAnalysisStrengthWeaknessSettingsRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<SWOTAnalysisStrengthWeaknessSettings?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<SWOTAnalysisStrengthWeaknessSettings>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<SWOTAnalysisStrengthWeaknessSettings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<SWOTAnalysisStrengthWeaknessSettings, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<IEnumerable<SWOTAnalysisStrengthWeaknessSettings>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
    }
}

