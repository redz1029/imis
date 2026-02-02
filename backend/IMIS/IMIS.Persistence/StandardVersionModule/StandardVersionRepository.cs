using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.StandardVersionModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.StandardVersionModule
{
    public class StandardVersionRepository : BaseRepository<StandardVersion, int, ImisDbContext, User>, IStandardVersionRepository
    {
        public StandardVersionRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<IEnumerable<StandardVersion>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<StandardVersion?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<StandardVersion>()
                .FirstOrDefaultAsync(sv => sv.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<StandardVersion>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(sv => EF.Functions.Like(sv.VersionName, $"{name}%"))
                .Take(noOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<StandardVersion, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<StandardVersion, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<StandardVersion?> GetByIdWithIsoStandardsAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(sv => sv.IsoStandards)
                .AsNoTracking()
                .FirstOrDefaultAsync(sv => sv.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
