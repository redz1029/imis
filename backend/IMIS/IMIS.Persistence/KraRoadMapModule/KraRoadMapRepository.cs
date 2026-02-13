using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.KraRoadMapModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadMapModule
{
    public class KraRoadMapRepository
        : BaseRepository<KraRoadMap, long, ImisDbContext, User>, IkraRoadMapRepository
    {
        public KraRoadMapRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        //// ====== Get specific deliverables for a Role ======       
        public async Task<List<KraRoadMapDeliverable>> GetDeliverablesByRoleAsync(int? kraId, int? fromYear, int? toYear, string roleId, CancellationToken cancellationToken)
        {
            var roadMapIds = await ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .Where(r => r.RoleId == roleId && !r.IsDeleted
                            && (!kraId.HasValue || r.KraId == kraId.Value)
                            && (!fromYear.HasValue
                                || (r.KraRoadMapPeriod!.StartYear.Year <= toYear.GetValueOrDefault(fromYear.Value)
                                    && r.KraRoadMapPeriod.EndYear.Year >= fromYear.Value)))
                .Select(r => r.Id)
                .ToListAsync(cancellationToken);

            if (!roadMapIds.Any())
                return new List<KraRoadMapDeliverable>();

            var deliverablesQuery = ReadOnlyDbContext.Set<KraRoadMapDeliverable>()
                .AsNoTracking()
                .Where(d => roadMapIds.Contains(d.KraRoadMapId)
                            && (!fromYear.HasValue || (toYear.HasValue
                                ? d.Year >= fromYear.Value && d.Year <= toYear.Value
                                : d.Year == fromYear.Value)));

            return await deliverablesQuery.ToListAsync(cancellationToken);
        }

        //// ====== Get All deliverables for a Role ======
        public async Task<List<KraRoadMapDeliverable>> GetDeliverablesAsync(int? kraId, int? fromYear, int? toYear, CancellationToken cancellationToken)
        {
            var roadMapIds = await ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .Where(r => !r.IsDeleted  && (!kraId.HasValue || r.KraId == kraId.Value) && (!fromYear.HasValue
                         || (r.KraRoadMapPeriod!.StartYear.Year <= toYear.GetValueOrDefault(fromYear.Value)
                          && r.KraRoadMapPeriod.EndYear.Year >= fromYear.Value)))
                .Select(r => r.Id)
                .ToListAsync(cancellationToken);

            if (!roadMapIds.Any())
                return new List<KraRoadMapDeliverable>();

            var deliverablesQuery = ReadOnlyDbContext.Set<KraRoadMapDeliverable>()
                .AsNoTracking()
                .Where(d => roadMapIds.Contains(d.KraRoadMapId) && (!fromYear.HasValue || (toYear.HasValue
                     ? d.Year >= fromYear.Value && d.Year <= toYear.Value
                     : d.Year == fromYear.Value)));

            return await deliverablesQuery.ToListAsync(cancellationToken);
        }

        //// ====== Get All deliverables for a Role ======
        public async Task<List<KraRoadMapKpi>> GetKpisAsync(int? kraid, int? fromYear, int? toYear, CancellationToken cancellationToken)
        {
            var roadMapIds = await ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .Where(r => !r.IsDeleted && (!kraid.HasValue || r.KraId == kraid.Value) && (!fromYear.HasValue || (r.KraRoadMapPeriod!.StartYear.Year <= toYear.GetValueOrDefault(fromYear.Value)
                          && r.KraRoadMapPeriod.EndYear.Year >= fromYear.Value)))
                .Select(r => r.Id)
                .ToListAsync(cancellationToken);

            if (!roadMapIds.Any())
                return new List<KraRoadMapKpi>();

            var kpisQuery = ReadOnlyDbContext.Set<KraRoadMapKpi>()
                .AsNoTracking()
                .Where(k => roadMapIds.Contains(k.KraRoadMapId));

            return await kpisQuery.ToListAsync(cancellationToken);
        }

        //// ====== Get specific deliverables for a Role ======
        public async Task<List<KraRoadMapKpi>> GetKpisByRoleAsync(int? kraid, string roleId, int? fromYear, int? toYear, CancellationToken cancellationToken)
        {
            var roadMapIds = await ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .Where(r => !r.IsDeleted && r.RoleId == roleId && (!kraid.HasValue || r.KraId == kraid.Value) && (!fromYear.HasValue
                         || (r.KraRoadMapPeriod!.StartYear.Year <= toYear.GetValueOrDefault(fromYear.Value)
                            && r.KraRoadMapPeriod.EndYear.Year >= fromYear.Value)))
                .Select(r => r.Id)
                .ToListAsync(cancellationToken);

            if (!roadMapIds.Any())
                return new List<KraRoadMapKpi>();

            var kpisQuery = ReadOnlyDbContext.Set<KraRoadMapKpi>()
                .AsNoTracking()
                .Where(k => roadMapIds.Contains(k.KraRoadMapId));

            return await kpisQuery.ToListAsync(cancellationToken);
        }

        public async Task<KraRoadMap?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadMap>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<IEnumerable<KraRoadMapDescriptionFilter>> GetKraDescriptionsByKraIdAsync(int kraId,
        CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadMap>()
            .AsNoTracking()
            .Where(rm => rm.KraId == kraId && rm.Deliverables != null)
            .SelectMany(rm => rm.Deliverables!)
            .Where(d => !string.IsNullOrEmpty(d.KraDescription))
            .Select(d => new KraRoadMapDescriptionFilter { KraDescription = d.KraDescription! })
            .Distinct()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
        
        public async Task<IEnumerable<KraRoadMapFilter>> GetByKraYearAndDescriptionAsync(
        int kraId,
        int year,
        string kraDescription,
        bool isDirect,
        CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .Where(rm =>                    
                    rm.KraId == kraId &&
                    rm.Deliverables != null
                )
                .SelectMany(rm => rm.Deliverables!
                    .Where(d =>                      
                        d.Year == year &&
                        d.KraDescription == kraDescription
                    )
                    .Select(d => new KraRoadMapFilter
                    {
                        Id = d.Id,
                        KraId = rm.KraId!.Value,
                        KraRoadMapId = rm.Id,
                        KraDescription = d.KraDescription!,
                        Year = d.Year,

                        DeliverableDescription = isDirect
                            ? d.DeliverableDescription!
                            : null
                    })
                )
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<KraRoadMap, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
            .AsNoTracking()
            .Include(x => x.Kra)
            .Include(x => x.KraRoadMapPeriod)
            .Include(x => x.Deliverables)
            .Include(x => x.Kpis);

            return await EntityPageList<KraRoadMap, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
        }
        
        public async Task<KraRoadMap?> GetByIdWithChildrenAsync(long id, CancellationToken cancellationToken = default)
        {
            var entity = await _entities
                .Include(x => x.Kra)
                .Include(x => x.KraRoadMapPeriod)
                .Include(x => x.Deliverables)
                .Include(x => x.Kpis)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);

            if (entity?.Deliverables != null)
            {
                entity.Deliverables = entity.Deliverables
                    .OrderBy(d => d.IsEnabler)  
                    .ThenBy(d => d.Year)        
                    .ToList();
            }

            return entity;
        }

        // Get all for Admin StandardUser Role
        public async Task<IEnumerable<KraRoadMap>?> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .Include(x => x.Kra)
            .Include(x => x.KraRoadMapPeriod)
            .Include(x => x.Deliverables)
            .Include(x => x.Kpis)
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }

        //Get for UserId Role     
        public async Task<List<KraRoadMap>> GetAllForUserIdAsync(string roleId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<KraRoadMap>()
            .Include(x => x.Kra)
            .Include(x => x.KraRoadMapPeriod)
            .Include(x => x.Deliverables)
            .Include(x => x.Kpis)
            .Where(x => x.RoleId == roleId)
            .ToListAsync(cancellationToken);
        }

        public async Task<List<(long KraRoadMapId, DateTime StartYear, DateTime EndYear)>> GetRoadMapPeriodsAsync(List<KraRoadMapDeliverable> deliverables, CancellationToken cancellationToken)
        {
            var roadmapIds = deliverables.Select(d => d.KraRoadMapId).Distinct().ToList();

            var roadmapPeriods = await ReadOnlyDbContext.Set<KraRoadMap>()
            .AsNoTracking()
            .Where(r => roadmapIds.Contains(r.Id))
            .Select(r => new
            {
                r.Id,
                StartYear = r.KraRoadMapPeriod!.StartYear.ToDateTime(TimeOnly.MinValue),
                EndYear = r.KraRoadMapPeriod.EndYear.ToDateTime(TimeOnly.MinValue)
            })
            .ToListAsync(cancellationToken);

            return roadmapPeriods
            .Select(r => (r.Id, r.StartYear, r.EndYear))
            .ToList();
        }

        public async Task<List<(long KraRoadMapId, DateTime StartYear, DateTime EndYear)>> GetRoadMapPeriodsForKpisAsync(List<KraRoadMapKpi> kpis, CancellationToken cancellationToken)
        {
            var roadmapIds = kpis.Select(k => k.KraRoadMapId).Distinct().ToList();

            var roadmapPeriods = await ReadOnlyDbContext.Set<KraRoadMap>()
            .AsNoTracking()
            .Where(r => roadmapIds.Contains(r.Id))
            .Select(r => new
            {
                r.Id,
                r.KraRoadMapPeriod!.StartYear,
                r.KraRoadMapPeriod.EndYear
            })
            .ToListAsync(cancellationToken);
           
            return roadmapPeriods
            .Select(r => (r.Id, r.StartYear.ToDateTime(TimeOnly.MinValue), r.EndYear.ToDateTime(TimeOnly.MinValue)))
            .ToList();
        }

    }
}
