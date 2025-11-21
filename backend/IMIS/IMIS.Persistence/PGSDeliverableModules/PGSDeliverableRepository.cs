using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PGSModules
{
    public class PGSDeliverableRepository(ImisDbContext dbContext)
    : BaseRepository<PgsDeliverable, long, ImisDbContext>(dbContext), IPGSDeliverableRepository
    {
        public async Task<long?> GetCurrentYearPeriodIdAsync(int currentYear, CancellationToken cancellationToken)
        {
            var period = await _entities
                .Where(d => d.PerfomanceGovernanceSystem!.PgsPeriod != null &&
                            d.PerfomanceGovernanceSystem.PgsPeriod.StartDate.Year == currentYear)
                .Select(d => d.PerfomanceGovernanceSystem!.PgsPeriod.Id)
                .FirstOrDefaultAsync(cancellationToken);

            return period == 0 ? (long?)null : period;
        }
        public async Task<List<int>> GetUserOfficeIdsAsync(string userId, CancellationToken cancellationToken)
        {           
            return await ReadOnlyDbContext.Set<AuditorOffices>()
               .Where(ao => ao.Auditor != null
                         && ao.Auditor.UserId == userId
                         && ao.Auditor.IsActive)
               .Select(ao => ao.OfficeId)
               .Distinct()
               .ToListAsync(cancellationToken)
               .ConfigureAwait(false);
        }
       
        public async Task<EntityPageList<PgsDeliverable, long>> GetFilteredAsync(PgsDeliverableMonitorFilter filter, CancellationToken cancellationToken)
        {
            var query = _entities
                .Include(d => d.PerfomanceGovernanceSystem)
                    .ThenInclude(pgs => pgs!.Office)
                .Include(d => d.PerfomanceGovernanceSystem)
                    .ThenInclude(pgs => pgs!.PgsPeriod)
                .Include(d => d.Kra)
                .Where(d => !d.IsDeleted);
          
            if (filter.PgsPeriodId.HasValue)
                query = query.Where(d => d.PerfomanceGovernanceSystem!.PgsPeriod.Id == filter.PgsPeriodId.Value);

            if (filter.OfficeId.HasValue)
                query = query.Where(d => d.PerfomanceGovernanceSystem!.Office.Id == filter.OfficeId.Value);

            if (filter.IsDirect.HasValue)
                query = query.Where(d => d.IsDirect == filter.IsDirect.Value);

            if (filter.KraId.HasValue)
                query = query.Where(d => d.KraId == filter.KraId.Value);
          
            query = query.OrderByDescending(d => d.Id);

            return await EntityPageList<PgsDeliverable, long>.CreateAsync(query, filter.Page, filter.PageSize, cancellationToken);
        }     
        public async Task<EntityPageList<PgsDeliverable, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
          
            return await EntityPageList<PgsDeliverable, long>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
         
        }    
        async Task<List<PgsDeliverable>?> IPGSDeliverableRepository.GetAll(CancellationToken cancellationToken)
        {
           return await _entities        
          .Include(o => o.Kra)
          .AsNoTracking()
          .ToListAsync(cancellationToken)
          .ConfigureAwait(false);
        }      
    }
}

