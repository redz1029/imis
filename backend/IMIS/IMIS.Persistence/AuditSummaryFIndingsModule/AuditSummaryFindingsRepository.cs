using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditSummaryFindingsModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditSummaryFindingsModule
{
    public class AuditSummaryFindingsRepository : BaseRepository<AuditSummaryFIndings, int, ImisDbContext, User>, IAuditSummaryFindingsRepository
    {
        public AuditSummaryFindingsRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<AuditSummaryFIndings?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditSummaryFIndings>()
                .Include(x => x.Criteria)
                .Include(x => x.NcarStatus)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<AuditSummaryFIndings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditSummaryFIndings, int>.CreateAsync(
                _entities.AsNoTracking()
                    .Include(x => x.Criteria)
                    .Include(x => x.NcarStatus),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditSummaryFIndings?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}