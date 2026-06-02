using Base.Abstractions;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadMapDeliverableModule
{
    public class KraRoadMapDeliverableRepository : BaseRepository<KraRoadMapDeliverable, long, ImisDbContext, User>, IKraRoadMapDeliverableRepository
    {
        public KraRoadMapDeliverableRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<List<KraRoadMapDeliverable>> GetDeliverablesByIdsAsync(List<long> ids, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext
                .Set<KraRoadMapDeliverable>()
                .AsNoTracking()
                .Where(x =>
                    ids.Contains(x.Id) &&
                    !x.IsDeleted)
                .ToListAsync(cancellationToken);
        }

        public async Task<List<(long KraRoadMapId, DateTime StartYear, DateTime EndYear)>> GetRoadMapPeriodsAsync(List<KraRoadMapDeliverable> deliverables, CancellationToken cancellationToken)
        {
            var roadmapIds = deliverables
                .Select(d => d.KraRoadMapId)
                .Distinct()
                .ToList();

            var roadmapPeriods = await ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .Include(x => x.KraRoadMapPeriod)
                .Where(x => roadmapIds.Contains(x.Id))
                .Select(x => new
                {
                    KraRoadMapId = x.Id,
                    StartYear = x.KraRoadMapPeriod!.StartYear
                        .ToDateTime(TimeOnly.MinValue),

                    EndYear = x.KraRoadMapPeriod.EndYear
                        .ToDateTime(TimeOnly.MinValue)
                })
                .ToListAsync(cancellationToken);

            return roadmapPeriods
                .Select(x => (
                    x.KraRoadMapId,
                    x.StartYear,
                    x.EndYear))
                .ToList();
        }
        public async Task<List<KraRoadMapDeliverable>> GetByRoadMapIdAsync(long kraRoadMapId, int year,  CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadMapDeliverable>()
                .AsNoTracking()
                .Where(x =>
                    !x.IsDeleted &&
                    x.KraRoadMapId == kraRoadMapId &&
                    x.Year == year)
                .ToListAsync(cancellationToken);
        }       
    }
}
