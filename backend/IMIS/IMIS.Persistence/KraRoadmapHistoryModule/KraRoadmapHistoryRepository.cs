using Base.Abstractions;
using IMIS.Application.KraRoadmapHistoryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadmapHistoryModule
{
    public class KraRoadmapHistoryRepository : BaseRepository<KraRoadmapHistory, long, ImisDbContext, User>, IKraRoadmapHistoryRepository
    {
        public KraRoadmapHistoryRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<IEnumerable<KraRoadmapHistory>?> GetAll(long? kraRoadMapId, CancellationToken cancellationToken)
        {
            IQueryable<KraRoadmapHistory> query = _entities
            .AsNoTracking()
            .Include(x => x.User)
            .Include(x => x.KraRoadMap)
                .ThenInclude(r => r.Kra);
            if (kraRoadMapId.HasValue)
            {
                query = query.Where(x => x.KraRoadMapId == kraRoadMapId.Value);
            }

             return await query
            .OrderByDescending(x => x.PostingDate).ToListAsync(cancellationToken).ConfigureAwait(false);
        }
    }
}
