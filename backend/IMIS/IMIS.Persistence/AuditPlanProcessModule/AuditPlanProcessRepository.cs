using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditPlanProcessModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditPlanProcessModule
{
    public class AuditPlanProcessRepository(ImisDbContext dbContext)
        : BaseRepository<AuditPlanProcess, int, ImisDbContext, User>(dbContext), IAuditPlanProcessRepository
    {
        public async Task<EntityPageList<AuditPlanProcess, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditPlanProcess, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditPlanProcess?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            // Accesses the set directly to ensure we can find the entity for deletion state change
            return await ReadOnlyDbContext.Set<AuditPlanProcess>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<AuditPlanProcess>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditPlanProcess?> GetWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.Office)
                .Include(x => x.AuditPlanEntry)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Filtered Query Implementations ---

        public async Task<IEnumerable<AuditPlanProcess>> FilterByOfficeId(int officeId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.OfficeId == officeId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanProcess>> FilterByAuditPlanEntryId(int entryId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.AuditPlanEntryId == entryId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}