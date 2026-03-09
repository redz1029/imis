using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditPlanPersonResponsibleModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditPlanPersonResponsibleModule
{
    public class AuditPlanPersonResponsibleRepository
        : BaseRepository<AuditPlanPersonResponsible, int, ImisDbContext, User>, IAuditPlanPersonResponsibleRepository
    {
        public AuditPlanPersonResponsibleRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<EntityPageList<AuditPlanPersonResponsible, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .AsNoTracking()
                .OrderBy(x => x.Name);

            return await EntityPageList<AuditPlanPersonResponsible, int>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanPersonResponsible>?> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .OrderBy(x => x.Name)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanPersonResponsible>?> GetActiveAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.IsActive)
                .OrderBy(x => x.Name)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanPersonResponsible>?> SearchByNameAsync(string name, CancellationToken cancellationToken)
        {
            var searchTerm = name.Trim();
            return await _entities
                .Where(x => EF.Functions.Like(x.Name, $"%{searchTerm}%"))
                .OrderBy(x => x.Name)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditPlanPersonResponsible?> GetByNameAsync(string name, CancellationToken cancellationToken)
        {
            var searchName = name.Trim();
            return await _entities
                .FirstOrDefaultAsync(x => x.Name.ToLower() == searchName.ToLower(), cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanPersonResponsible>?> GetByPositionAsync(string position, CancellationToken cancellationToken)
        {
            var searchTerm = position.Trim();
            return await _entities
                .Where(x => x.Position != null && EF.Functions.Like(x.Position, $"%{searchTerm}%"))
                .OrderBy(x => x.Name)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<bool> ExistsByNameAsync(string name, int? excludeId = null, CancellationToken cancellationToken = default)
        {
            var searchName = name.Trim();
            var query = _entities.Where(x => x.Name.ToLower() == searchName.ToLower());

            if (excludeId.HasValue)
            {
                query = query.Where(x => x.Id != excludeId.Value);
            }

            return await query.AnyAsync(cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Fetches the entity using ReadOnlyDbContext for lightweight soft-delete operations.
        /// </summary>
        public async Task<AuditPlanPersonResponsible?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditPlanPersonResponsible>()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}