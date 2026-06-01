using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditNcarStatusModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditNcarStatusModule
{
    public class AuditNcarStatusRepository : BaseRepository<AuditNcarStatus, int, ImisDbContext, User>, IAuditNcarStatusRepository
    {
        public AuditNcarStatusRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<AuditNcarStatus?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditNcarStatus>()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<AuditNcarStatus, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditNcarStatus, int>.CreateAsync(
                _entities.AsNoTracking(),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditNcarStatus?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}