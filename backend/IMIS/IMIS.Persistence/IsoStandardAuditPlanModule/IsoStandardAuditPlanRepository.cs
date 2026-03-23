using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.IsoStandardAuditPlanModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.IsoStandardAuditPlanModule
{
    public class IsoStandardAuditPlanRepository(ImisDbContext dbContext)
        : BaseRepository<IsoStandardAuditPlan, int, ImisDbContext, User>(dbContext), IIsoStandardAuditPlanRepository
    {
        public async Task<EntityPageList<IsoStandardAuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<IsoStandardAuditPlan, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IsoStandardAuditPlan?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<IsoStandardAuditPlan>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<IsoStandardAuditPlan>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IsoStandardAuditPlan?> GetWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.IsoStandard)
                .Include(x => x.AuditPlanEntry)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Filtered Query Implementations ---

        public async Task<IEnumerable<IsoStandardAuditPlan>> FilterByAuditPlanEntryId(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.AuditPlanEntryId == auditPlanEntryId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<IsoStandardAuditPlan>> FilterByIsoStandardId(int isoStandardId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.IsoStandardId == isoStandardId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}