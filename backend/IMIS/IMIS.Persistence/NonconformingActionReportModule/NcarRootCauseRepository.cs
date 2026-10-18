using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.NonconformingActionReportModule
{
    public class NcarRootCauseRepository : BaseRepository<NcarRootCause, long, ImisDbContext, User>, INcarRootCauseRepository
    {
        public NcarRootCauseRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<NcarRootCause?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<NcarRootCause>()
                .Include(x => x.NonconformingActionReport)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<NcarRootCause, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<NcarRootCause, long>.CreateAsync(
                _entities.AsNoTracking(),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<NcarRootCause?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
