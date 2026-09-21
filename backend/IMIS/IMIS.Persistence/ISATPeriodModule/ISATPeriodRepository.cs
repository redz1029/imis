using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.IndividualStrategicAlignmentTreePeriodModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.ISATPeriodModule
{
    public class ISATPeriodRepository : BaseRepository<ISATPeriod, int, ImisDbContext, User>, IISATPeriodRepository
    {
        public ISATPeriodRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<ISATPeriod?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<ISATPeriod>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<EntityPageList<ISATPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<ISATPeriod, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);

        }
        public async Task<IEnumerable<ISATPeriod>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
    }
}
