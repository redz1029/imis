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
            return await _dbContext.PgsDeliverableScoreHistories
                .Where(o => !o.IsDeleted)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public new async Task<PgsDeliverableScoreHistory> SaveOrUpdateAsync(PgsDeliverableScoreHistory pgsDeliverableScoreHistory, CancellationToken cancellationToken)
        {
            if (pgsDeliverableScoreHistory == null) throw new ArgumentNullException(nameof(pgsDeliverableScoreHistory));
            // Check if the entity already exists
            var existingpgsDeliverableScoreHistory = await _dbContext.PgsDeliverableScoreHistories
                .FirstOrDefaultAsync(d => d.Id == pgsDeliverableScoreHistory.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingpgsDeliverableScoreHistory != null)
            {
                // Update existing entity
                _dbContext.Entry(existingpgsDeliverableScoreHistory).CurrentValues.SetValues(pgsDeliverableScoreHistory);
            }
            else
            {
                // Add new entity
                await _dbContext.PgsDeliverableScoreHistories.AddAsync(pgsDeliverableScoreHistory, cancellationToken).ConfigureAwait(false);
            }
            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return pgsDeliverableScoreHistory;
        }
    }
}
