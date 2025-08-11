using Base.Abstractions;
using IMIS.Application.PgsDeliverableScoreHistoryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsDeliverableScoreHistoryModule
{
    public class PgsDeliverableScoreHistoryRepository : BaseRepository<PgsDeliverableScoreHistory, long, ImisDbContext>, IPgsDeliverableScoreHistoryRepository
    {
        public PgsDeliverableScoreHistoryRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<IEnumerable<PgsDeliverableScoreHistory>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities              
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }      
    }
}
