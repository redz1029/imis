using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PerfomanceGovernanceSystemModule; 
using IMIS.Application.PgsModule;
using IMIS.Domain;
using IMIS.Persistence;
using Microsoft.EntityFrameworkCore;


public class PerfomanceGovernanceSystemRepository : BaseRepository<PerfomanceGovernanceSystem, long, ImisDbContext>, IPerfomanceGovernanceSystemRepository
{
    public PerfomanceGovernanceSystemRepository(ImisDbContext dbContext) : base(dbContext) { }

    public async Task<List<PerfomanceGovernanceSystem>> GetByOfficeIdsAsync(List<int> officeIds, CancellationToken cancellationToken)
    {
        return await ReadOnlyDbContext.Set<PerfomanceGovernanceSystem>()
            
            .Include(p => p.Office)
            .Include(p => p.PgsDeliverables)
            .Include(p => p.PgsSignatories)
             .Include(p => p.PgsPeriod)
            .Where(p => officeIds.Contains(p.OfficeId))
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
    }

    public async Task<PerfomanceGovernanceSystem?> GetWithIncludesAsync(int id, CancellationToken cancellationToken)
    {
        return await _entities
            .Include(p => p.PgsDeliverables)
            .Include(p => p.PgsSignatories)
            .Include(p => p.PgsReadinessRating)
               .Include(p => p.Office)
               .Include(p => p.PgsPeriod)
            .FirstOrDefaultAsync(p => p.Id == id, cancellationToken);
    }
   
    public async Task<IEnumerable<PerfomanceGovernanceSystem>> GetByUserIdAsync(string userId, CancellationToken cancellationToken)
    {      
        var userOfficeIds = await ReadOnlyDbContext.Set<UserOffices>()
            .Where(u => u.UserId == userId)
            .Select(u => u.OfficeId)
            .ToListAsync(cancellationToken);

        if (!userOfficeIds.Any())
            return Enumerable.Empty<PerfomanceGovernanceSystem>();
       
        var allOfficeIds = await GetAllChildOfficeIdsAsync(userOfficeIds, cancellationToken);
       
        var pgsRecords = await _entities
            .Where(p => allOfficeIds.Contains(p.OfficeId))
            .Include(p => p.PgsPeriod)
            .Include(p => p.Office)
                .ThenInclude(o => o.UserOffices)
            .Include(p => p.PgsReadinessRating)
            .Include(p => p.PgsSignatories)
            .Include(p => p.PgsDeliverables)
            .AsNoTracking()
            .ToListAsync(cancellationToken);

        return pgsRecords;
    }

    private async Task<List<int>> GetAllChildOfficeIdsAsync(List<int> officeIds, CancellationToken cancellationToken)
    {
        var allIds = new HashSet<int>(officeIds);

        var childIds = await ReadOnlyDbContext.Set<Office>()
            .Where(o => o.ParentOfficeId.HasValue && officeIds.Contains(o.ParentOfficeId.Value))
            .Select(o => o.Id)
            .ToListAsync(cancellationToken);

        if (childIds.Any())
        {
            allIds.UnionWith(childIds);
            var grandChildIds = await GetAllChildOfficeIdsAsync(childIds, cancellationToken);
            allIds.UnionWith(grandChildIds);
        }

        return allIds.ToList();
    }

    public async Task<PerfomanceGovernanceSystem?> GetByIdAsync(int id, CancellationToken cancellationToken)
    {
         return await _entities
        .Include(p => p.PgsPeriod)
        .Include(p => p.Office)
        .Include(p => p.PgsDeliverables)
        .ThenInclude(d => d.Kra)
        .Include(p => p.PgsDeliverables)
        .ThenInclude(d => d.PgsDeliverableScoreHistory)
        .Include(p => p.PgsReadinessRating)
        .Include(p => p.PgsSignatories!)                
        .FirstOrDefaultAsync(p => p.Id == id, cancellationToken);
    }

    public async Task<PerfomanceGovernanceSystem?> GetByUserIdAndPgsIdAsync(string userId, int pgsId, CancellationToken cancellationToken)
    {
        var pgs = await _entities
         .Where(p => p.Id == pgsId)
         .Include(p => p.PgsPeriod)
         .Include(p => p.PgsReadinessRating)
         .Include(p => p.PgsSignatories)
         .Include(p => p.PgsDeliverables)
             .ThenInclude(d => d.Kra)
         .Include(p => p.Office)
             .ThenInclude(o => o.UserOffices)
         .Include(p => p.Office)
             .ThenInclude(o => o.ParentOffice)
                 .ThenInclude(po => po!.UserOffices)
         .FirstOrDefaultAsync(cancellationToken);
        
        if (pgs != null)
        {
            var inChildOffice = pgs.Office.UserOffices!.Any(u => u.UserId == userId);
            var inParentOffice = pgs.Office.ParentOffice?.UserOffices!.Any(u => u.UserId == userId) == true;

            if (!inChildOffice && !inParentOffice)
                return null;
        }

        return pgs;

    }

    //Get Pgs Report: Filter by Id
    public async Task<PerfomanceGovernanceSystem?> ReportGetByIdAsync(int id, CancellationToken cancellationToken)
    {
        return await _entities
        .Include(p => p.PgsPeriod)
        .Include(p => p.Office)
        .Include(p => p.PgsDeliverables)
        .ThenInclude(d => d.Kra)
        .Include(p => p.PgsReadinessRating)
        .Include(p => p.PgsSignatories)
        .ThenInclude(d => d.PgsSignatoryTemplate)
        .FirstOrDefaultAsync(p => p.Id == id, cancellationToken);
    }
    // Get Pgs, Filter by Pgs Period Id
    public async Task<IEnumerable<PerfomanceGovernanceSystem>> GetAllAsyncFilterByPgsPeriod(long? pgsPeriodId, CancellationToken cancellationToken)
    {
        var query = _entities
        .Where(p => (pgsPeriodId == null || p.PgsPeriod.Id == pgsPeriodId))
        .Include(pgs => pgs.PgsPeriod)
        .Include(pgs => pgs.Office)                          
        .Include(pgs => pgs.PgsReadinessRating)
        .Include(pgs => pgs.PgsSignatories);
        return await query.ToListAsync(cancellationToken);
    }
    // Get all Pgs
    public async Task<IEnumerable<PerfomanceGovernanceSystem>> GetAll(CancellationToken cancellationToken)
    {
        return await _entities
        .Include(p => p.PgsPeriod)
        .Include(p => p.Office)
        .Include(p => p.PgsDeliverables)
        .ThenInclude(d => d.Kra)
        .Include(p => p.PgsReadinessRating)
        .Include(p => p.PgsSignatories)
        .ThenInclude(d => d.PgsSignatoryTemplate)
        .AsNoTracking()
        .ToListAsync(cancellationToken);
    }

    // Get Pgs, Filter by all Paginated
    public async Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
    {
       
       return await EntityPageList<PerfomanceGovernanceSystem, long>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
        
    }
    // Get Pgs, Filter by Pgs Period Id with pagination
    public async Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetPaginatedPgsPeriodIdAsync(
    long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken)
    {       
        var query = _entities        
        .Include(pgs => pgs.PgsPeriod)
        .Include(pgs => pgs.Office)
        .Include(pgs => pgs.PgsReadinessRating)
        .Include(p => p.PgsSignatories)
        .AsNoTracking(); 
        
        if (pgsPeriodId.HasValue)
        {
            query = query.Where(p => p.PgsPeriod.Id == pgsPeriodId.Value);
        }
        // Apply pagination using EntityPageList
        var paginatedResult = await EntityPageList<PerfomanceGovernanceSystem, long>
        .CreateAsync(query, page, pageSize, cancellationToken)
        .ConfigureAwait(false);
        return paginatedResult;
    }
    // Save or Update Record
  
    public Task<int> CountAsync(CancellationToken cancellationToken)
    {
        return ReadOnlyDbContext.Set<PerfomanceGovernanceSystem>().CountAsync(cancellationToken);
    }
    public async Task<IEnumerable<PerfomanceGovernanceSystem>> GetPagedAsync(int skip, int pageSize, CancellationToken cancellationToken)
    {
        return await ReadOnlyDbContext.Set<PerfomanceGovernanceSystem>().Skip(skip).Take(pageSize).ToListAsync(cancellationToken).ConfigureAwait(false);
    }


    public async Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetFilteredPGSAsync(
    PgsFilter filter,
    string userId,
    CancellationToken cancellationToken)
    {

        var userPgs = _entities
            .Where(p => !p.IsDeleted &&
                p.Office!.UserOffices!.Any(u => u.UserId == userId && u.OfficeId == p.OfficeId))
            .Select(p => p.Id);

        var forApprovalPgs = _entities
            .Where(p => !p.IsDeleted &&           
                 ReadOnlyDbContext.Set<PgsSignatoryTemplate>()
                    .Where(template =>
                        template.OfficeId == p.OfficeId &&
                        template.IsActive &&
                        template.DefaultSignatoryId == userId)
                    .OrderBy(template => template.OrderLevel)
                    .Any(template =>
                        !ReadOnlyDbContext.Set<PgsSignatory>().Any(sig =>
                            sig.PgsId == p.Id &&
                            sig.PgsSignatoryTemplateId == template.Id)))
            .Select(p => p.Id);

        var combinedIds = await userPgs
            .Union(forApprovalPgs)
            .Distinct()
            .ToListAsync(cancellationToken);

        var filteredQuery = _entities
            .Where(p => combinedIds.Contains(p.Id));

        if (filter.FromDate != null && filter.ToDate != null)
        {
            filteredQuery = filteredQuery.Where(p =>
                p.PgsPeriod.StartDate >= filter.FromDate &&
                p.PgsPeriod.EndDate <= filter.ToDate);
        }
        else if (filter.FromDate != null)
        {
            filteredQuery = filteredQuery.Where(p =>
                p.PgsPeriod.StartDate >= filter.FromDate);
        }
        else if (filter.ToDate != null)
        {
            filteredQuery = filteredQuery.Where(p =>
                p.PgsPeriod.EndDate <= filter.ToDate);
        }

        if (filter.OfficeId != null)
        {
            filteredQuery = filteredQuery.Where(p => p.OfficeId == filter.OfficeId);
        }

        var fullQuery = filteredQuery
            .Include(p => p.PgsPeriod)
            .Include(p => p.Office)
            .Include(p => p.PgsReadinessRating)
            .Include(p => p.PgsSignatories);

        // Apply pagination
        return await EntityPageList<PerfomanceGovernanceSystem, long>
            .CreateAsync(fullQuery, filter.Page, filter.PageSize, cancellationToken)
            .ConfigureAwait(false);
    } 
}
