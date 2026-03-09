using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditPlanProcessModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditPlanProcessModule
{
    
    public class AuditPlanProcessRepository : BaseRepository<AuditPlanProcess, int, ImisDbContext, User>, IAuditPlanProcessRepository
    {
      
        private readonly ImisDbContext _localContext;

        public AuditPlanProcessRepository(ImisDbContext dbContext) : base(dbContext)
        {
            _localContext = dbContext;
        }

        #region READ QUERIES

        public async Task<EntityPageList<AuditPlanProcess, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .AsNoTracking()
                .OrderBy(x => x.Name);

            return await EntityPageList<AuditPlanProcess, int>
                .CreateAsync(query, page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanProcess>?> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .OrderBy(x => x.Name)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanProcess>?> GetActiveAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.IsActive)
                .AsNoTracking()
                .OrderBy(x => x.Name)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanProcess>?> SearchByNameAsync(string name, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Name.Contains(name))
                .AsNoTracking()
                .OrderBy(x => x.Name)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditPlanProcess?> GetByNameAsync(string name, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Name == name, cancellationToken)
                .ConfigureAwait(false);
        }

        #endregion

        #region VALIDATION & INFRASTRUCTURE

        public async Task<bool> ExistsByNameAsync(string name, int? excludeId = null, CancellationToken cancellationToken = default)
        {
            var query = _entities.AsNoTracking().Where(x => x.Name == name);

            if (excludeId.HasValue)
            {
                query = query.Where(x => x.Id != excludeId.Value);
            }

            return await query.AnyAsync(cancellationToken).ConfigureAwait(false);
        }

       
        public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            
            return await _localContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
        }

        public async Task<AuditPlanProcess?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            // Using ReadOnlyDbContext which is a protected member of BaseRepository
            return await ReadOnlyDbContext.Set<AuditPlanProcess>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        #endregion
    }
}