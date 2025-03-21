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

            var pagperiod = await EntityPageList<PgsPeriod, int>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
            
            return pagperiod;
        }
        public async Task<IEnumerable<PgsPeriod>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.PgsPeriod
                .Where(o => !o.IsDeleted) 
                .AsNoTracking()           
                .ToListAsync(cancellationToken) 
                .ConfigureAwait(false);
        }
        public new async Task<PgsPeriod> SaveOrUpdateAsync(PgsPeriod PgsPeriod, CancellationToken cancellationToken)
        {
            if (PgsPeriod == null) throw new ArgumentNullException(nameof(PgsPeriod));

            var existingPgsPeriod = await _dbContext.PgsPeriod
                .FirstOrDefaultAsync(d => d.Id == PgsPeriod.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingPgsPeriod != null)
            {
                // Update the existing PgsPeriod entity
                _dbContext.Entry(existingPgsPeriod).CurrentValues.SetValues(PgsPeriod);
            }
            else
            {
                // Add the new PgsPeriod entity
                await _dbContext.PgsPeriod.AddAsync(PgsPeriod, cancellationToken).ConfigureAwait(false);
            }
            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);           
            return PgsPeriod;
        }
    }
}
