using Base.Abstractions;
using IMIS.Application.PgsDeliverableHistoryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsDeliverableHistoryModule
{
    public class PgsDeliverableHistoryRepository : BaseRepository<PgsDeliverableHistory, long, ImisDbContext>, IPgsDeliverableHistoryRepository
    {
        public PgsDeliverableHistoryRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public new async Task<PgsDeliverableHistory> SaveOrUpdateAsync(PgsDeliverableHistory pgsDeliverableHistory, CancellationToken cancellationToken)
        {
            if (pgsDeliverableHistory == null) throw new ArgumentNullException(nameof(pgsDeliverableHistory));
            // Check if the entity already exists
            var existingpgsDeliverableScoreHistory = await _dbContext.PgsDeliverableScoreHistories
                .FirstOrDefaultAsync(d => d.Id == pgsDeliverableHistory.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingpgsDeliverableScoreHistory != null)
            {
                // Update existing entity
                _dbContext.Entry(existingpgsDeliverableScoreHistory).CurrentValues.SetValues(pgsDeliverableHistory);
            }
            else
            {
                // Add new entity
                await _dbContext.PgsDeliverableHistory.AddAsync(pgsDeliverableHistory, cancellationToken).ConfigureAwait(false);
            }
            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return pgsDeliverableHistory;
        }
    }
}
