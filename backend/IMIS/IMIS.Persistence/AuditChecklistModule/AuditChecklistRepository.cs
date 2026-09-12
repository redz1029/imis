using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditChecklistModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditChecklistModule
{
    public class AuditChecklistRepository : BaseRepository<AuditChecklist, int, ImisDbContext, User>, IAuditChecklistRepository
    {
        private readonly ImisDbContext _localDbContext;

        public AuditChecklistRepository(ImisDbContext dbContext) : base(dbContext)
        {
            _localDbContext = dbContext;
        }

        private IQueryable<AuditChecklist> WithDetails(IQueryable<AuditChecklist> query) => query
            .Include(x => x.AuditChecklistQNA)
                .ThenInclude(q => q!.IsoStandard)
            .Include(x => x.AuditPlanEntry)
                .ThenInclude(e => e!.AuditPlanProcesses)
                    .ThenInclude(p => p.Office)
            .Include(x => x.AuditPlanEntry)
                .ThenInclude(e => e!.IsoAuditors)
                    .ThenInclude(a => a.Team);

        public async Task<AuditChecklist?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await WithDetails(ReadOnlyDbContext.Set<AuditChecklist>().AsQueryable())
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditChecklist>> GetByAuditPlanEntryIdAsync(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            return await WithDetails(_entities.AsNoTracking())
                .Where(x => x.AuditPlanEntryId == auditPlanEntryId && !x.IsDeleted)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<AuditChecklist, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditChecklist, int>.CreateAsync(
                WithDetails(_entities.AsNoTracking()),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditChecklist?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditChecklist>> GetAll(CancellationToken cancellationToken)
        {
            return await WithDetails(_entities.AsNoTracking())
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        // Guarantees instance reference to save changes
        public async Task SaveOrUpdateAsync(CancellationToken cancellationToken)
        {
            await _localDbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
        }
    }
}