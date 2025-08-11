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
            
            return await EntityPageList<PgsPeriod, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);            
        
        }
        public async Task<IEnumerable<PgsPeriod>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities         
            .AsNoTracking()           
            .ToListAsync(cancellationToken) 
            .ConfigureAwait(false);
        }      
       
    }
}
