using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditComFindingsModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditComFindingsModule
{
    public class AuditComFindingsRepository : BaseRepository<AuditComFindings, int, ImisDbContext, User>, IAuditComFindingsRepository
    {
        public AuditComFindingsRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<AuditComFindings?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditComFindings>()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<AuditComFindings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditComFindings, int>.CreateAsync(
                _entities.AsNoTracking(),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditComFindings?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}