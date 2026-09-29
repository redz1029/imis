using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.NonconformingActionReportModule
{
    public class NcarCorrectionActionRepository : BaseRepository<NcarCorrectionAction, long, ImisDbContext, User>, INcarCorrectionActionRepository
    {
        public NcarCorrectionActionRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<NcarCorrectionAction?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<NcarCorrectionAction>()
                .Include(x => x.NonconformingActionReport)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<NcarCorrectionAction, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<NcarCorrectionAction, long>.CreateAsync(
                _entities.AsNoTracking(),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<NcarCorrectionAction?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
