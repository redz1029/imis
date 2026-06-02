using Base.Abstractions;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadMapKpiModule
{
    public class KraRoadMapKpiRepository : BaseRepository<KraRoadMapKpi, int, ImisDbContext, User>, IKraRoadMapKpiRepository
    {
        public KraRoadMapKpiRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<List<KraRoadMapKpi>> GetKpisByIdsAsync(List<long> ids, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext
                .Set<KraRoadMapKpi>()
                .AsNoTracking()
                .Where(x =>
                    ids.Contains(x.Id) &&
                    !x.IsDeleted)
                .ToListAsync(cancellationToken);
        }

        public async Task<List<KraRoadMapKpi>> GetKpisByRoadMapIdAsync(long kraRoadMapId, int year, CancellationToken cancellationToken)
        {
            var validRoadMapIds = await ReadOnlyDbContext
                .Set<KraRoadMap>()
                .AsNoTracking()
                .Where(x =>
                    x.Id == kraRoadMapId &&
                    x.KraRoadMapPeriod!.StartYear.Year <= year &&
                    x.KraRoadMapPeriod.EndYear.Year >= year)
                .Select(x => x.Id)
                .ToListAsync(cancellationToken);

            return await ReadOnlyDbContext
                .Set<KraRoadMapKpi>()
                .AsNoTracking()
                .Where(x =>
                    !x.IsDeleted &&
                    validRoadMapIds.Contains(x.KraRoadMapId))
                .ToListAsync(cancellationToken);
        }
        
        public async Task<List<(long KraRoadMapId, DateTime StartYear, DateTime EndYear)>> GetRoadMapPeriodsForKpisAsync(List<KraRoadMapKpi> kpis, CancellationToken cancellationToken)
        {
            var roadmapIds = kpis
                .Select(k => k.KraRoadMapId)
                .Distinct()
                .ToList();

            var roadmapPeriods = await ReadOnlyDbContext
                .Set<KraRoadMap>()
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
    }
}
