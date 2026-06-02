using Base.Abstractions;
using IMIS.Application.KraRoadmapAccomplishmentModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadMapAccomplishmentModule
{
    public class KraRoadMapAccomplishmentRepository(ImisDbContext dbContext) : BaseRepository<KraRoadmapAccomplishment, long, ImisDbContext, User>(dbContext), IKraRoadmapAccomplishmentRepository
    {
      
        public async Task<List<KraRoadmapAccomplishment>> GetByDeliverableIdAsync(
        long deliverableId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(a => a.KraRoadMapDeliverableId == deliverableId)
                .Include(a => a.User)
                .ToListAsync(cancellationToken);
        }
    }
}
