using Base.Abstractions;
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
