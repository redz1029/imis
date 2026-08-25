using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.OperationReviewProtocolModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.OperationReviewProtocolModule
{
    public class OperationReviewProtocolRepository : BaseRepository<OperationReviewProtocol, long, ImisDbContext, User>, IOperationReviewProtocolRepository
    {
        public OperationReviewProtocolRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<OperationReviewProtocol?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<OperationReviewProtocol>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<List<PgsDeliverableAccomplishment>> GetDeliverableByIdAsync(long pgsId, int month, int year, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<PgsDeliverableAccomplishment>()
            .AsNoTracking()
            .Include(x => x.PgsDeliverable)
            .Where(x =>
                x.PostingDate.Month == month &&
                x.PostingDate.Year == year &&
                x.PgsDeliverable!.PerfomanceGovernanceSystemId == pgsId)
            .ToListAsync(cancellationToken);
        }
        
        public async Task<OperationReviewProtocol?> ReportGetByIdAsync(long operationReviewProtocolId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.Department)
                .Include(x => x.Division)
                .Include(x => x.User)
                .Include(x => x.PerformanceGovernanceSystem)
                    .ThenInclude(x => x!.PgsDeliverables)
                .FirstOrDefaultAsync(x => x.Id == operationReviewProtocolId, cancellationToken).ConfigureAwait(false);
        }

        public async Task<OperationReviewProtocol?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.Department)
                .Include(x => x.Division)
                .Include(x => x.User)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken).ConfigureAwait(false);
        }
       

        public async Task<IEnumerable<OperationReviewProtocol>?> GetAll(long? performanceGovernanceSystemId, CancellationToken cancellationToken)
        {
            var query = _entities.AsNoTracking().AsQueryable();

            if (performanceGovernanceSystemId.HasValue)
            {
                query = query.Where(x => x.PerformanceGovernanceSystemId == performanceGovernanceSystemId);
            }
            return await query.ToListAsync(cancellationToken).ConfigureAwait(false);
        }
            
        public async Task<EntityPageList<OperationReviewProtocol, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<OperationReviewProtocol, long>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
        }
    }
}
