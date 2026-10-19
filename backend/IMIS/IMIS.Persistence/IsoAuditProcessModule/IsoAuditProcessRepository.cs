using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.IsoAuditProcessModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.IsoAuditProcessModule
{
    public class IsoAuditProcessRepository(ImisDbContext dbContext)
        : BaseRepository<IsoAuditProcess, int, ImisDbContext, User>(dbContext), IIsoAuditProcessRepository
    {
        public async Task<EntityPageList<IsoAuditProcess, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<IsoAuditProcess, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IsoAuditProcess?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            // Using ReadOnlyDbContext for the existence check before soft-deletion
            return await ReadOnlyDbContext.Set<IsoAuditProcess>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<IsoAuditProcess>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IsoAuditProcess?> GetWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.AuditPlanEntry) // Including the related AuditPlanEntry
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Filtered Query Implementations ---

        public async Task<IEnumerable<IsoAuditProcess>> FilterByAuditPlanEntryId(int entryId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.AuditPlanEntryId == entryId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<IsoAuditProcess>> FilterByStatus(bool isActive, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.IsActive == isActive)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}