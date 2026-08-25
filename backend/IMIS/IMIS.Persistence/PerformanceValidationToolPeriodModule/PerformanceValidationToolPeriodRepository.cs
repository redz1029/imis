using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PerformanceValidationToolPeriodModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PerformanceValidationToolPeriodModule
{
    public class PerformanceValidationToolPeriodRepository : BaseRepository<PerformanceValidationToolPeriod, int, ImisDbContext, User>, IPerformanceValidationToolPeriodRepository
    {
        public PerformanceValidationToolPeriodRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<PerformanceValidationToolPeriod?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<PerformanceValidationToolPeriod>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<PerformanceValidationToolPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<PerformanceValidationToolPeriod, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<IEnumerable<PerformanceValidationToolPeriod>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }


    }
}
