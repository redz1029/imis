using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.NonconformingActionReportModule
{
    public class NcarCorrectiveActionRepository : BaseRepository<NcarCorrectiveAction, long, ImisDbContext, User>, INcarCorrectiveActionRepository
    {
        public NcarCorrectiveActionRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<NcarCorrectiveAction?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<NcarCorrectiveAction>()
                .Include(x => x.NonconformingActionReport)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<NcarCorrectiveAction, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<NcarCorrectiveAction, long>.CreateAsync(
                _entities.AsNoTracking(),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<NcarCorrectiveAction?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
