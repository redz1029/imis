using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsSummaryNarrativeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsSummaryNarrativeModule
{
    public class PgsSummaryNarrativeRepository : BaseRepository<PgsSummaryNarrative, int, ImisDbContext>, IPGSSummaryNarrativeRepository
    {
        public PgsSummaryNarrativeRepository(ImisDbContext dbContext) : base(dbContext)
        {

        }
        // Get all for Auditor Head
        public async Task<IEnumerable<PgsSummaryNarrative>> GetAllForAuditorHeadAsync(int? periodId,
        int? office,
        CancellationToken cancellationToken)
        {
            var query = _entities
                .AsNoTracking();

            query = query.Where(n => n.OfficeId == null || (office.HasValue && n.OfficeId == office.Value));

            if (periodId.HasValue) 
                query = query.Where(n => n.PgsPeriodId == periodId.Value);

            return await query.ToListAsync(cancellationToken).ConfigureAwait(false);
        }       
        public async Task<PgsSummaryNarrative?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<PgsSummaryNarrative>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        // Get all for Auditor
        public async Task<IEnumerable<PgsSummaryNarrative>> GetNarrativesByAuditorAsync(
        string userId,
        int? periodId,
        int? office, 
        CancellationToken cancellationToken)
        {
            var auditor = await ReadOnlyDbContext.Set<Auditor>()
                .FirstOrDefaultAsync(a => a.UserId == userId && !a.IsDeleted, cancellationToken);

            if (auditor == null)
                return Enumerable.Empty<PgsSummaryNarrative>();

            var assignedOfficeIds = await ReadOnlyDbContext.Set<AuditorOffices>()
                .Where(o => o.AuditorId == auditor.Id && !o.IsDeleted)
                .Select(o => o.OfficeId)
                .Distinct()
                .ToListAsync(cancellationToken);

            if (!assignedOfficeIds.Any())
                return Enumerable.Empty<PgsSummaryNarrative>();

            var query = ReadOnlyDbContext.Set<PgsSummaryNarrative>()
                .Where(n => !n.IsDeleted && n.OfficeId.HasValue && assignedOfficeIds.Contains(n.OfficeId.Value));

            if (periodId.HasValue)
                query = query.Where(n => n.PgsPeriodId == periodId.Value);

            if (office.HasValue)
                query = query.Where(n => n.OfficeId == office.Value);

            return await query.ToListAsync(cancellationToken);
        }
        public async Task<EntityPageList<PgsSummaryNarrative, int>> GetPaginatedAsync(
        int page,
        int pageSize, CancellationToken cancellationToken)
        {

            return await EntityPageList<PgsSummaryNarrative, int>.CreateAsync(_entities.AsNoTracking(),
            page, 
            pageSize, 
            cancellationToken
            ).ConfigureAwait(false);

        }      
        public async Task<IEnumerable<PgsSummaryNarrative>> GetAllFilteredNarrativeForHeadsAsync(
        int? periodId,
        int? office,
        CancellationToken cancellationToken)
        {
            var query = _entities
                .AsNoTracking()
                .Where(n => n.OfficeId != null); 

            if (periodId.HasValue)
                query = query.Where(n => n.PgsPeriodId == periodId.Value);

            if (office.HasValue)
                query = query.Where(n => n.OfficeId == office.Value);

            return await query
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<IEnumerable<PgsSummaryNarrative>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }       
        public async Task<PgsSummaryNarrative?> GetByPeriodIdAsync(int pgsPeriodId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .FirstOrDefaultAsync(n => n.PgsPeriodId == pgsPeriodId, cancellationToken)
                .ConfigureAwait(false);
        }     
        public async Task<List<PgsSummaryNarrative>> GetNarrativesByFilterAsync(PgsDeliverableSummaryNarrativeFilter filter, CancellationToken cancellationToken)
        {
            var query = _entities                
                .AsNoTracking()
                .Include(n => n.PgsPeriod)
                .AsQueryable();
         
            if (filter.PgsPeriodId.HasValue)
                query = query.Where(n => n.PgsPeriodId == filter.PgsPeriodId.Value);
           
            return await query
                .Skip((filter.Page - 1) * filter.PageSize)
                .Take(filter.PageSize)
                .ToListAsync(cancellationToken);
        }      
        public async Task<List<PgsDeliverable>> GetFilteredDeliverablesAsync(IEnumerable<int> periodIds,
        PgsDeliverableSummaryNarrativeFilter filter,
        CancellationToken cancellationToken)
        {
            var query = ReadOnlyDbContext.Set<PgsDeliverable>()
                .Include(d => d.Kra)
                .Include(d => d.PerfomanceGovernanceSystem)
                    .ThenInclude(pgs => pgs!.PgsPeriod)
                .Include(d => d.PerfomanceGovernanceSystem)
                    .ThenInclude(pgs => pgs!.Office)
                .Where(d => d.PerfomanceGovernanceSystem != null &&
                            periodIds.Contains(d.PerfomanceGovernanceSystem.PgsPeriod.Id));

            if (!string.IsNullOrEmpty(filter.OfficeId) && int.TryParse(filter.OfficeId, out var officeId))
                query = query.Where(d => d.PerfomanceGovernanceSystem!.OfficeId == officeId);
        
            if (!string.IsNullOrWhiteSpace(filter.Kra))
            {
                var kraInput = filter.Kra.Trim();
                if (int.TryParse(kraInput, out var kraId))
                    query = query.Where(d => d.Kra != null && d.Kra.Id == kraId);
                else
                {
                    var kraName = kraInput.ToLower();
                    query = query.Where(d => d.Kra != null && d.Kra.Name.ToLower() == kraName);
                }
            }
          
            if (filter.MinScore.HasValue)
                query = query.Where(d => d.PercentDeliverables >= filter.MinScore.Value);
           
            if (filter.MaxScore.HasValue)
                query = query.Where(d => d.PercentDeliverables <= filter.MaxScore.Value);

            return await query.ToListAsync(cancellationToken);
        }
    }
}
