using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using IMIS.Persistence;
using Microsoft.EntityFrameworkCore;

public class PerfomanceGovernanceSystemRepository : BaseRepository<PerfomanceGovernanceSystem, long, ImisDbContext>, IPerfomanceGovernanceSystemRepository
{
    public PerfomanceGovernanceSystemRepository(ImisDbContext dbContext) : base(dbContext)
    {

    }
    public async Task<IEnumerable<PerfomanceGovernanceSystem>> GetAll(CancellationToken cancellationToken)
    {

        return await _dbContext.PerformanceGovernanceSystem
        .Where(o => !o.IsDeleted)
        .Include(pgs => pgs.PgsPeriod)
        .Include(pgs => pgs.Office)
        .Include(pgs => pgs.PgsDeliverables)
        .Include(pgs => pgs.PgsReadinessRating)
        .AsNoTracking()
        .ToListAsync(cancellationToken);
    } 
    public async Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
    {
        var query = _dbContext.PerformanceGovernanceSystem.Where(k => !k.IsDeleted).AsNoTracking();

        var perfomanceGovernanceSystem = await EntityPageList<PerfomanceGovernanceSystem, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);

        return perfomanceGovernanceSystem;
    }
    public new async Task<PerfomanceGovernanceSystem> SaveOrUpdateAsync(PerfomanceGovernanceSystem perfomanceGovernanceSystem, CancellationToken cancellationToken)
    {
        if (perfomanceGovernanceSystem == null) throw new ArgumentNullException(nameof(perfomanceGovernanceSystem));
       
        var existingPerfomanceGovernanceSystem = await _dbContext.PerformanceGovernanceSystem
            .FirstOrDefaultAsync(d => d.Id == perfomanceGovernanceSystem.Id, cancellationToken)
            .ConfigureAwait(false);

        if (existingPerfomanceGovernanceSystem != null)
        {           
            _dbContext.Entry(existingPerfomanceGovernanceSystem).CurrentValues.SetValues(perfomanceGovernanceSystem);
        }
        else
        {           
            await _dbContext.PerformanceGovernanceSystem.AddAsync(perfomanceGovernanceSystem, cancellationToken).ConfigureAwait(false);
        }

        // Save changes to the database
        await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
        return perfomanceGovernanceSystem;
    }
   
    public Task<int> CountAsync(CancellationToken cancellationToken)
    {
       
        return _dbContext.PerformanceGovernanceSystem.CountAsync(cancellationToken);
    }
    public async Task<IEnumerable<PerfomanceGovernanceSystem>> GetPagedAsync(int skip, int pageSize, CancellationToken cancellationToken)
    {
    
        return await _dbContext.PerformanceGovernanceSystem.Skip(skip).Take(pageSize).ToListAsync(cancellationToken).ConfigureAwait(false);
    }
}
