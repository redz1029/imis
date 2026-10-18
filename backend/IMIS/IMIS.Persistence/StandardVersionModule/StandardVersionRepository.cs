using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.StandardVersionModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.StandardVersionModule
{
    public class StandardVersionRepository(ImisDbContext dbContext) : BaseRepository<StandardVersion, int, ImisDbContext, User>(dbContext), IStandardVersionRepository
    {
        public async Task<EntityPageList<StandardVersion, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<StandardVersion, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<StandardVersion?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<StandardVersion>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<StandardVersion>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<StandardVersion?> GetWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()// Includes the collection of associated IsoStandards
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Filtered Query Implementations ---

        public async Task<IEnumerable<StandardVersion>> FilterByActiveStatus(bool isActive, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.isActive == isActive)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<StandardVersion>> FilterByVersionName(string versionName, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.VersionName.Contains(versionName))
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

        }
    }
}