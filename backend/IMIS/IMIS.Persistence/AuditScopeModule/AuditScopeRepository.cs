using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditScopeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditScopeModule
{
    public class AuditScopeRepository : BaseRepository<AuditScope, int, ImisDbContext, User>, IAuditScopeRepository
    {
        public AuditScopeRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<AuditScope?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditScope>()
                .Include(x => x.AuditProcessAudited)
                .Include(x => x.AuditorTeams)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<AuditScope, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditScope, int>.CreateAsync(
                _entities.AsNoTracking()
                    .Include(x => x.AuditProcessAudited)
                    .Include(x => x.AuditorTeams),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditScope?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}