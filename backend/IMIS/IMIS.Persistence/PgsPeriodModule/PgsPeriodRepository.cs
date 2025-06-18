using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsPeriodModule
{
    public class PgsPeriodRepository : BaseRepository<PgsPeriod, int, ImisDbContext>, IPgsPeriodRepository
    {
        public PgsPeriodRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<EntityPageList<PgsPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _dbContext.PgsPeriod.Where(k => !k.IsDeleted).AsNoTracking();

            var pagPeriod = await EntityPageList<PgsPeriod, int>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
            
            return pagPeriod;
        }
        public async Task<IEnumerable<PgsPeriod>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.PgsPeriod
                .Where(o => !o.IsDeleted) 
                .AsNoTracking()           
                .ToListAsync(cancellationToken) 
                .ConfigureAwait(false);
        }      
        public new async Task<PgsPeriod> SaveOrUpdateAsync(PgsPeriod pgsPeriod, CancellationToken cancellationToken)
        {
            if (pgsPeriod == null) throw new ArgumentNullException(nameof(pgsPeriod));

            try
            {
                var existing = await _dbContext.PgsPeriod
                    .AsNoTracking()
                    .FirstOrDefaultAsync(d => d.Id == pgsPeriod.Id, cancellationToken);

                if (existing != null)
                {
                    _dbContext.PgsPeriod.Update(pgsPeriod); 
                }
                else
                {
                    await _dbContext.PgsPeriod.AddAsync(pgsPeriod, cancellationToken);
                }

                await _dbContext.SaveChangesAsync(cancellationToken);
                return pgsPeriod;
            }
            catch (DbUpdateConcurrencyException ex)
            {
                throw new InvalidOperationException("Concurrency conflict: The record was updated by another user.", ex);
            }
        }

    }
}
