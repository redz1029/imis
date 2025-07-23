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
       
        public async Task SaveChangesAsync(CancellationToken cancellationToken)
        {
            await _dbContext.SaveChangesAsync(cancellationToken);

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

            if(filter.ScoreRangeFrom.HasValue)
                query = query.Where(d => d.PgsDeliverableScoreHistory!.Any(s => s.Score >= filter.ScoreRangeFrom.Value));

            if(filter.ScoreRangeTo.HasValue)
                query = query.Where(d => d.PgsDeliverableScoreHistory!.Any(s => s.Score <= filter.ScoreRangeTo.Value));

            if(filter.KraId.HasValue)
                query = query.Where(d => d.KraId == filter.KraId.Value);

            return await EntityPageList<PgsDeliverable, long>
                .CreateAsync(query, filter.Page, filter.PageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<PgsDeliverable, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _dbContext.Deliverable.Where(k => !k.IsDeleted).AsNoTracking();
            var pgsDeliverable = await EntityPageList<PgsDeliverable, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
            return pgsDeliverable;
        }

        public new async Task<PgsDeliverable> SaveOrUpdateAsync(PgsDeliverable pgsDeliverable, CancellationToken cancellationToken)
        {
            if (pgsDeliverable == null) throw new ArgumentNullException(nameof(pgsDeliverable));
            var existingPgsDeliverable = await _dbContext.Deliverable
                .FirstOrDefaultAsync(d => d.Id == pgsDeliverable.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingPgsDeliverable != null)
            {
                _dbContext.Entry(existingPgsDeliverable).CurrentValues.SetValues(pgsDeliverable);
            }
            else
            {
                await _dbContext.Deliverable.AddAsync(pgsDeliverable, cancellationToken).ConfigureAwait(false);
            }
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return pgsDeliverable;
        }     

        async Task<List<PgsDeliverable>?> IPGSDeliverableRepository.GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.Deliverable
          .Where(o => !o.IsDeleted)
          .Include(o => o.Kra)
          .AsNoTracking()
          .ToListAsync(cancellationToken)
          .ConfigureAwait(false);
        }
      
    }
}

