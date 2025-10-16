using Base.Abstractions;
using IMIS.Application.BreakThroughScoringModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.BreakThroughScoringModule
{
    public class BreakThroughScoringRepository : BaseRepository<BreakThroughScoring, int, ImisDbContext>, IBreakThroughScoringRepository
    {
        public BreakThroughScoringRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<BreakThroughScoring?> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken)
        {
            return await _entities
            .FirstOrDefaultAsync(a => a.PgsDeliverableId == deliverableId, cancellationToken);
        }

    }
}
