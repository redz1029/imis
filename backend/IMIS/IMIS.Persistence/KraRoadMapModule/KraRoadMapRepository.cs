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

        // ====== Get specific Point - Person for Deliverable  ======
        public async Task<List<KraRoadMapDeliverable>> GetDeliverablesByRoleAsync(int? kraId, int? year, string roleId, CancellationToken cancellationToken)
        {
            var roadMapQuery = ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .Where(r => r.RoleId == roleId);

            if (kraId.HasValue)
                roadMapQuery = roadMapQuery.Where(r => r.KraId == kraId.Value);

            var roadMapIds = await roadMapQuery
                .Select(r => r.Id)
                .ToListAsync(cancellationToken);

            if (!roadMapIds.Any())
                return new List<KraRoadMapDeliverable>();

            var deliverablesQuery = ReadOnlyDbContext.Set<KraRoadMapDeliverable>()
                .AsNoTracking()
                .Where(d => !d.IsDeleted && roadMapIds.Contains(d.KraRoadMapId));

            if (year.HasValue)
                deliverablesQuery = deliverablesQuery.Where(d => d.Year == year.Value);

            return await deliverablesQuery.ToListAsync(cancellationToken);
        }
     
        // ====== Get All Point - Person for Deliverable  ======
        public async Task<List<KraRoadMapDeliverable>> GetDeliverablesAsync(int? kraid, int? year, CancellationToken cancellationToken)
        {
            var roadMapQuery = ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking();
            
            if (kraid.HasValue)
                roadMapQuery = roadMapQuery.Where(r => r.KraId == kraid.Value);

            var roadMapIds = await roadMapQuery.Select(r => r.Id).ToListAsync(cancellationToken);

            if (!roadMapIds.Any())
                return new List<KraRoadMapDeliverable>();

            var deliverablesQuery = ReadOnlyDbContext.Set<KraRoadMapDeliverable>()
                .AsNoTracking()
                .Where(d => !d.IsDeleted && roadMapIds.Contains(d.KraRoadMapId));

            if (year.HasValue)
                deliverablesQuery = deliverablesQuery.Where(d => d.Year == year.Value);

            return await deliverablesQuery.ToListAsync(cancellationToken);
        }

        // ====== Get All Point - Person for KPI  ======
        public async Task<List<KraRoadMapKpi>> GetKpisAsync(int? kraid, CancellationToken cancellationToken)
        {
            var roadMapQuery = ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .Where(r => !r.IsDeleted);

            if (kraid.HasValue)
                roadMapQuery = roadMapQuery.Where(r => r.KraId == kraid.Value);

            var roadMapIds = await roadMapQuery
                .Select(r => r.Id)
                .ToListAsync(cancellationToken);

            if (!roadMapIds.Any())
                return new List<KraRoadMapKpi>();

            var kpiQuery = ReadOnlyDbContext.Set<KraRoadMapKpi>()
                .AsNoTracking()
                .Where(k => !k.IsDeleted && roadMapIds.Contains(k.KraRoadMapId));

            return await kpiQuery.ToListAsync(cancellationToken);
        }

        // ======Get specific Point - Person for KPI  ======
        public async Task<List<KraRoadMapKpi>> GetKpisByRoleAsync(int? kraid, string roleId, CancellationToken cancellationToken)
        {
            var roadMapQuery = ReadOnlyDbContext.Set<KraRoadMap>()
                .AsNoTracking()
                .Where(r => r.RoleId == roleId);

            if (kraid.HasValue)
                roadMapQuery = roadMapQuery.Where(r => r.KraId == kraid.Value);

            var roadMapIds = await roadMapQuery
                .Select(r => r.Id)
                .ToListAsync(cancellationToken);

            if (!roadMapIds.Any())
                return new List<KraRoadMapKpi>();

            return await ReadOnlyDbContext.Set<KraRoadMapKpi>()
                .AsNoTracking()
                .Where(k => !k.IsDeleted && roadMapIds.Contains(k.KraRoadMapId))
                .ToListAsync(cancellationToken);
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
    }
}
