using Base.Abstractions;
using IMIS.Application.KraRoadmapKpiAccomplishmentModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadMapKpiAccomplishmentModule
{
    public class KraRoadMapKpiAccomplishmentRepository(ImisDbContext dbContext) : BaseRepository<KraRoadmapKpiAccomplishment, long, ImisDbContext, User>(dbContext), IKraRoadmapKpiAccomplishmentRepository
    {
        public async Task<List<KraRoadmapKpiAccomplishment>> GetByKpiIdAsync(long kpiId, CancellationToken cancellationToken)
        {
            return await _entities
            .Where(a => a.KraRoadMapKpiId == kpiId)
            .Include(a => a.User)                
            .ToListAsync(cancellationToken);
        }
    }
}
