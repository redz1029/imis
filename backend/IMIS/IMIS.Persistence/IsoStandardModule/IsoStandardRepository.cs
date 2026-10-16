using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.IsoStandardModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.IsoStandardModule
{
    public class IsoStandardRepository : BaseRepository<IsoStandard, long, ImisDbContext, User>, IIsoStandardRepository
    {
        public IsoStandardRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<IEnumerable<IsoStandard>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .Include(iso => iso.Version)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<IsoStandard>?> FilterByVersionId(int versionId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(iso => iso.VersionID == versionId && iso.isActive)
                .Include(iso => iso.Version)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<IsoStandard>?> FilterByClauseRef(string clauseRef, int noOfResults, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(iso => EF.Functions.Like(iso.ClauseRef, $"{clauseRef}%") && iso.isActive)
                .Include(iso => iso.Version)
                .Take(noOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<IsoStandard, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities.Include(iso => iso.Version).AsNoTracking();
            return await EntityPageList<IsoStandard, long>
                .CreateAsync(query, page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<IsoStandard, long>> GetPaginatedByVersionAsync(int versionId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .Where(iso => iso.VersionID == versionId)
                .Include(iso => iso.Version)
                .AsNoTracking();
            return await EntityPageList<IsoStandard, long>
                .CreateAsync(query, page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IsoStandard?> GetByIdWithVersionAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(iso => iso.Version)
                .AsNoTracking()
                .FirstOrDefaultAsync(iso => iso.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
