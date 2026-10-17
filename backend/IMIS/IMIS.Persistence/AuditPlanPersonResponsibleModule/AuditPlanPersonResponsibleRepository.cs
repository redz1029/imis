using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditPlanPersonResponsibleModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditPlanPersonResponsibleModule
{
    public class AuditPlanPersonResponsibleRepository(ImisDbContext dbContext)
        : BaseRepository<AuditPlanPersonResponsible, int, ImisDbContext, User>(dbContext), IAuditPlanPersonResponsibleRepository
    {
        public async Task<EntityPageList<AuditPlanPersonResponsible, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditPlanPersonResponsible, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditPlanPersonResponsible?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditPlanPersonResponsible>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<AuditPlanPersonResponsible>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditPlanPersonResponsible?> GetWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.AuditPlanEntry)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Filtered Query Implementations ---

        public async Task<IEnumerable<AuditPlanPersonResponsible>> FilterByAuditPlanEntryId(int entryId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.AuditPlanEntryId == entryId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanPersonResponsible>> SearchByName(string name, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.Name.Contains(name))
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}