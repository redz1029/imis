using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsSignatoryModule;
using IMIS.Domain;
using IMIS.Persistence;
using Microsoft.EntityFrameworkCore;


public class PerfomanceGovernanceSystemRepository : BaseRepository<PerfomanceGovernanceSystem, long, ImisDbContext>, IPerfomanceGovernanceSystemRepository
{
    public PerfomanceGovernanceSystemRepository(ImisDbContext dbContext) : base(dbContext) { }

    public async Task<IEnumerable<PerfomanceGovernanceSystem>> GetByUserIdAsync(string userId, CancellationToken cancellationToken)
    {
        var pgs = await _dbContext.PerformanceGovernanceSystem.Where(p => !p.IsDeleted &&
        p.Office!.UserOffices!.Any(u => u.UserId == userId && u.OfficeId == p.OfficeId))
          .Include(p => p.PgsPeriod)
          .Include(p => p.Office)
          .Include(p => p.PgsReadinessRating)
          .Include(p => p.PgsSignatories)
          .ToListAsync(cancellationToken).ConfigureAwait(false);
        return pgs;
    }   
    public async Task<PerfomanceGovernanceSystem?> GetByIdAsync(int id, CancellationToken cancellationToken)
    {
        return await _dbContext.PerformanceGovernanceSystem
            .Include(p => p.PgsPeriod)
            .Include(p => p.Office)
            .Include(p => p.PgsDeliverables)
                .ThenInclude(d => d.Kra)
            .Include(p => p.PgsDeliverables)
                .ThenInclude(d => d.PgsDeliverableScoreHistory)
            .Include(p => p.PgsReadinessRating)
            .Include(p => p.PgsSignatories!)
                //.ThenInclude(s => s.PgsSignatoryTemplate) // needed for OrderLevel
            .FirstOrDefaultAsync(p => p.Id == id && !p.IsDeleted, cancellationToken);
    }
    
    public async Task<List<PerfomanceGovernanceSystem>?> GetUserByIdSaveUpdateAsync(int id, CancellationToken cancellationToken)
    {
        return await _dbContext.PerformanceGovernanceSystem
            .Include(p => p.PgsPeriod)
            .Include(p => p.Office)
            .Include(p => p.PgsDeliverables)
                .ThenInclude(d => d.Kra)
            .Include(p => p.PgsDeliverables)
                .ThenInclude(d => d.PgsDeliverableScoreHistory)
            .Include(p => p.PgsReadinessRating)
            .Include(p => p.PgsSignatories!)
            //.ThenInclude(s => s.PgsSignatoryTemplate) // Uncomment if needed
            .Where(p => p.Id == id && !p.IsDeleted)
            .ToListAsync(cancellationToken);
    }

    //Get Pgs Report: Filter by Id
    public async Task<PerfomanceGovernanceSystem?> ReportGetByIdAsync(int id, CancellationToken cancellationToken)
    {
        return await _dbContext.PerformanceGovernanceSystem
        .Include(p => p.PgsPeriod)
        .Include(p => p.Office)
        .Include(p => p.PgsDeliverables)
        .ThenInclude(d => d.Kra)
        .Include(p => p.PgsReadinessRating)
        .Include(p => p.PgsSignatories)
         .ThenInclude(d => d.PgsSignatoryTemplate)
        .FirstOrDefaultAsync(p => p.Id == id && !p.IsDeleted, cancellationToken);
    }
    // Get Pgs, Filter by Pgs Period Id
    public async Task<IEnumerable<PerfomanceGovernanceSystem>> GetAllAsyncFilterByPgsPeriod(long? pgsPeriodId, CancellationToken cancellationToken)
    {
        var query = _dbContext.PerformanceGovernanceSystem
        .Where(p => !p.IsDeleted && (pgsPeriodId == null || p.PgsPeriod.Id == pgsPeriodId))
        .Include(pgs => pgs.PgsPeriod)
        .Include(pgs => pgs.Office)                          
        .Include(pgs => pgs.PgsReadinessRating)
        .Include(pgs => pgs.PgsSignatories);
        return await query.ToListAsync(cancellationToken);
    }
    // Get all Pgs
    public async Task<IEnumerable<PerfomanceGovernanceSystem>> GetAll(CancellationToken cancellationToken)
    {
        return await _dbContext.PerformanceGovernanceSystem
        .Where(o => !o.IsDeleted)
        .Include(pgs => pgs.PgsPeriod)
        .Include(pgs => pgs.Office)      
        .Include(pgs => pgs.PgsReadinessRating)
        .Include(pgs => pgs.PgsSignatories)
        .AsNoTracking()
        .ToListAsync(cancellationToken);
    } 
    // Get Pgs, Filter by all Paginated
    public async Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
    {
        var query = _dbContext.PerformanceGovernanceSystem.Where(k => !k.IsDeleted).AsNoTracking();
        var perfomanceGovernanceSystem = await EntityPageList<PerfomanceGovernanceSystem, long>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
        return perfomanceGovernanceSystem;
    }
    // Get Pgs, Filter by Pgs Period Id with pagination
    public async Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetPaginatedPgsPeriodIdAsync(
    long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken)
    {       
        var query = _dbContext.PerformanceGovernanceSystem
        .Where(k => !k.IsDeleted)
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
    public new async Task<PerfomanceGovernanceSystem> SaveOrUpdateAsync(PerfomanceGovernanceSystem perfomanceGovernanceSystem, CancellationToken cancellationToken)
    {
        if (perfomanceGovernanceSystem == null) throw new ArgumentNullException(nameof(perfomanceGovernanceSystem));

        var existingPerfomanceGovernanceSystem = await _dbContext.PerformanceGovernanceSystem
            .Include(p => p.PgsDeliverables)
            .Include(p => p.Office)
            .Include(p => p.PgsPeriod)
            .Include(p => p.PgsReadinessRating)
            .Include(p => p.PgsSignatories)
            .FirstOrDefaultAsync(d => d.Id == perfomanceGovernanceSystem.Id, cancellationToken)
            .ConfigureAwait(false);

        if (existingPerfomanceGovernanceSystem != null)
        {
            // Update main simple fields
            _dbContext.Entry(existingPerfomanceGovernanceSystem).CurrentValues.SetValues(perfomanceGovernanceSystem);

            // --- Update Office ---            
            if (perfomanceGovernanceSystem.Office != null)
            {
                var office = await _dbContext.Offices
                    .FirstOrDefaultAsync(o => o.Id == perfomanceGovernanceSystem.Office.Id, cancellationToken);

                if (office != null)
                {
                    existingPerfomanceGovernanceSystem.Office = office;
                }
            }

            // --- Update PgsPeriod ---           
            if (perfomanceGovernanceSystem.PgsPeriod != null)
            {
                var pgsPeriod = await _dbContext.PgsPeriod
                    .FirstOrDefaultAsync(o => o.Id == perfomanceGovernanceSystem.PgsPeriod.Id, cancellationToken);

                if (pgsPeriod != null)
                {
                    existingPerfomanceGovernanceSystem.PgsPeriod = pgsPeriod;
                }
            }

            // --- Update PgsReadinessRating ---                    
            if (perfomanceGovernanceSystem.PgsReadinessRating != null)
            {
                if (perfomanceGovernanceSystem.PgsReadinessRating.Id > 0)
                {
                    // Update existing Readiness
                    var pgsPeriodReadiness = await _dbContext.PgsReadiness
                        .FirstOrDefaultAsync(o => o.Id == perfomanceGovernanceSystem.PgsReadinessRating.Id, cancellationToken);

                    if (pgsPeriodReadiness != null)
                    {
                        pgsPeriodReadiness.CompetenceToDeliver = perfomanceGovernanceSystem.PgsReadinessRating.CompetenceToDeliver;
                        pgsPeriodReadiness.ResourceAvailability = perfomanceGovernanceSystem.PgsReadinessRating.ResourceAvailability;
                        pgsPeriodReadiness.ConfidenceToDeliver = perfomanceGovernanceSystem.PgsReadinessRating.ConfidenceToDeliver;
                    }
                }
                else
                {
                    // Insert new Readiness
                    existingPerfomanceGovernanceSystem.PgsReadinessRating = perfomanceGovernanceSystem.PgsReadinessRating;
                }
            }
            // --- Sync PgsDeliverables ---

            if (perfomanceGovernanceSystem.PgsDeliverables != null)
            {
                foreach (var deliverable in perfomanceGovernanceSystem.PgsDeliverables)
                {
                    var existingDeliverable = existingPerfomanceGovernanceSystem.PgsDeliverables!
                        .FirstOrDefault(d => d.Id == deliverable.Id);

                    if (existingDeliverable != null)
                    {
                        // Check if the score has changed before creating history
                         bool scoreChanged = existingDeliverable.PercentDeliverables != deliverable.PercentDeliverables;

                        _dbContext.Entry(existingDeliverable).CurrentValues.SetValues(deliverable);
                        existingDeliverable.PerfomanceGovernanceSystemId = existingPerfomanceGovernanceSystem.Id;

                        if (scoreChanged)
                        {
                            var history = new PgsDeliverableScoreHistory
                            {
                                Id = 0,
                                PgsDeliverableId = existingDeliverable.Id,
                                Date = DateTime.Now,
                                Score = deliverable.PercentDeliverables
                            };
                            _dbContext.Set<PgsDeliverableScoreHistory>().Add(history);
                        }
                    }
                    else
                    {
                        deliverable.PerfomanceGovernanceSystemId = existingPerfomanceGovernanceSystem.Id;
                        _dbContext.Entry(deliverable).State = EntityState.Added;
                    }
                }
            }

            // --- Sync PgsSignatories ---                     
            if (perfomanceGovernanceSystem.PgsSignatories != null)
            {
                foreach (var signatory in perfomanceGovernanceSystem.PgsSignatories)
                {
                    // Check if the signatory already exists in the system
                    var existingSignatory = existingPerfomanceGovernanceSystem.PgsSignatories!
                        .FirstOrDefault(s => s.Id == signatory.Id);

                    if (existingSignatory != null)
                    {
                        // Update existing signatory
                        _dbContext.Entry(existingSignatory).CurrentValues.SetValues(signatory);
                    }
                    else
                    {
                        // Ensure the PgsId is correct
                        if (existingPerfomanceGovernanceSystem.Id == 0)
                        {
                            throw new InvalidOperationException("Invalid PerformanceGovernanceSystem ID.");
                        }

                        signatory.PgsId = existingPerfomanceGovernanceSystem.Id;

                        if (_dbContext.Entry(signatory).State == EntityState.Detached)
                        {
                            _dbContext.Entry(signatory).State = EntityState.Added;
                        }

                        existingPerfomanceGovernanceSystem.PgsSignatories!.Add(signatory);
                    }
                }
            }

            try
            {
                // Save changes to the database
                await _dbContext.SaveChangesAsync();
            }
            catch (DbUpdateException dbEx)
            {
                // Handle DB update exceptions
                throw new InvalidOperationException("An error occurred while saving changes.", dbEx);
            }
            catch (Exception ex)
            {
                // Handle any other general exceptions
                throw new InvalidOperationException("An unexpected error occurred.", ex);
            }

        }
        else
        {
            // Insert new main entity
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
                _dbContext.PgsSignatoryTemplate
                    .Where(template =>
                        template.OfficeId == p.OfficeId &&
                        template.IsActive &&
                        template.DefaultSignatoryId == userId)
                    .OrderBy(template => template.OrderLevel)
                    .Any(template =>
                        !_dbContext.PgsSignatory.Any(sig =>
                            sig.PgsId == p.Id &&
                            sig.PgsSignatoryTemplateId == template.Id)))
            .Select(p => p.Id);

        var combinedIds = await userPgs
            .Union(forApprovalPgs)
            .Distinct()
            .ToListAsync(cancellationToken);
       
        var filteredQuery = _entities
            .Where(p => combinedIds.Contains(p.Id));

        if (filter.PgsPeriodId != null)
            filteredQuery = filteredQuery.Where(p => p.PgsPeriod.Id == filter.PgsPeriodId);

        if (filter.OfficeId != null)
            filteredQuery = filteredQuery.Where(p => p.OfficeId == filter.OfficeId);
       
        var fullQuery = filteredQuery
            .Include(p => p.PgsPeriod)
            .Include(p => p.Office)
            .Include(p => p.PgsReadinessRating)
            .Include(p => p.PgsSignatories);

        return await EntityPageList<PerfomanceGovernanceSystem, long>
            .CreateAsync(fullQuery, filter.Page, filter.PageSize, cancellationToken)
            .ConfigureAwait(false);
    }

    public async Task Disapprove(long pgsId, CancellationToken cancellationToken)
    {
        var pgs = await _entities
         .Include(p => p.PgsSignatories)!
             .ThenInclude(s => s.PgsSignatoryTemplate)
         .FirstOrDefaultAsync(p => p.Id == pgsId, cancellationToken)
         .ConfigureAwait(false);

        if (pgs == null)
            throw new InvalidOperationException($"PGS record with ID {pgsId} not found.");

        var signatoriesToRemove = pgs.PgsSignatories!
            .Where(s => s.PgsSignatoryTemplate?.OrderLevel > 1)
            .ToList();

        foreach (var signatory in signatoriesToRemove)
        {
            signatory.IsDeleted = true;
        }

        await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
    }
}
