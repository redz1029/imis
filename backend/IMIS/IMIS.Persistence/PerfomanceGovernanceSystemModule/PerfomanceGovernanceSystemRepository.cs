using System.Linq.Expressions;
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

    public async Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetPaginatedFilteredDeliverablesAsync(
    PgsDeliverableMonitoringDto filter,
    CancellationToken cancellationToken)
    {
        var baseQuery = _dbContext.Set<PerfomanceGovernanceSystem>()
            .Include(p => p.PgsPeriod)
            .Include(p => p.Office)
            .Include(p => p.PgsDeliverables)
                .ThenInclude(d => d.Kra)
            .AsQueryable();

        if (filter.PgsPeriodId is > 0)
        {
            baseQuery = baseQuery.Where(p => p.PgsPeriod.Id == filter.PgsPeriodId);
        }

        if (filter.Department is > 0)
        {
            baseQuery = baseQuery.Where(p => p.Office.Id == filter.Department);
        }

        if (filter.Kra is > 0)
        {
            baseQuery = baseQuery.Where(p => p.PgsDeliverables!.Any(d => d.KraId == filter.Kra));
        }

        if (!string.IsNullOrWhiteSpace(filter.KraDescription) && filter.KraDescription != "string")
        {
            baseQuery = baseQuery.Where(p => p.PgsDeliverables!.Any(d => d.KraDescription != null && d.KraDescription.Contains(filter.KraDescription)));
        }

        if (filter.IsDirect is not null)
        {
            baseQuery = baseQuery.Where(p => p.PgsDeliverables!.Any(d => d.IsDirect == filter.IsDirect));
        }

        if (!string.IsNullOrWhiteSpace(filter.Deliverable) && filter.Deliverable != "string")
        {
            baseQuery = baseQuery.Where(p => p.PgsDeliverables!.Any(d => d.DeliverableName.Contains(filter.Deliverable)));
        }

        if (filter.Score is > 0)
        {
            baseQuery = baseQuery.Where(p => p.PgsDeliverables!.Any(d => d.PercentDeliverables == filter.Score));
        }

        var statusFilter = new List<int>();
        if (!string.IsNullOrWhiteSpace(filter.DeliverableStatus) && filter.DeliverableStatus != "string")
        {
            statusFilter = filter.DeliverableStatus
                .Split(',', StringSplitOptions.RemoveEmptyEntries)
                .Select(s => int.TryParse(s, out var val) ? val : (int?)null)
                .Where(s => s.HasValue)
                .Select(s => s.Value)
                .ToList();
        }

        // Paging setup
        var page = filter.Page <= 0 ? 1 : filter.Page;
        var pageSize = filter.PageSize <= 0 ? 10 : filter.PageSize;
       
        var query = baseQuery.Select(p => new PerfomanceGovernanceSystem
        {
            Id = p.Id,
            PgsPeriod = p.PgsPeriod,
            Office = p.Office,
            Remarks = p.Remarks,
            PgsStatus = p.PgsStatus,
            PgsReadinessRating = p.PgsReadinessRating,
            PercentDeliverables = p.PercentDeliverables,
            PgsSignatories = p.PgsSignatories,
            IsDeleted = p.IsDeleted,
            RowVersion = p.RowVersion,

           
            PgsDeliverables = p.PgsDeliverables!
            .Where(d =>
                (filter.Kra == null || filter.Kra == 0 || d.KraId == filter.Kra) &&
                (string.IsNullOrWhiteSpace(filter.KraDescription) || filter.KraDescription == "string" || d.KraDescription!.Contains(filter.KraDescription)) &&
                (filter.IsDirect == null     || d.IsDirect == filter.IsDirect) &&
                (string.IsNullOrWhiteSpace(filter.Deliverable) || filter.Deliverable == "string" || d.DeliverableName.Contains(filter.Deliverable)) &&
                (filter.Score == null || filter.Score == 0 || d.PercentDeliverables == filter.Score) &&
                (statusFilter.Count == 0 || statusFilter.Contains((int)d.Status))
            
            )
            .Select(d => new PgsDeliverable
            {
                Id = d.Id,
                KraId = d.KraId,
                Kra = d.Kra,
                KraDescription = d.KraDescription,
                IsDirect = d.IsDirect,
                DeliverableName = d.DeliverableName,
                ByWhen = d.ByWhen,
                PercentDeliverables = d.PercentDeliverables,
                Status = d.Status,
                Remarks = d.Remarks,
                PgsDeliverableScoreHistory = d.PgsDeliverableScoreHistory,
                IsDeleted = d.IsDeleted,
                RowVersion = d.RowVersion
            })
            .ToList()

        });

        return await EntityPageList<PerfomanceGovernanceSystem, long>.CreateAsync(
            query, page, pageSize, cancellationToken);
    }

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
    // Get Pgs, Filter by Id
    public async Task<PerfomanceGovernanceSystem?> GetByIdAsync(int id, CancellationToken cancellationToken)
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
                        // Update existing deliverable
                        _dbContext.Entry(existingDeliverable).CurrentValues.SetValues(deliverable);

                        // Always save a new history record on update
                        var history = new PgsDeliverableScoreHistory
                        {
                            Id = 0,
                            PgsDeliverableId = existingDeliverable.Id,
                            Date = DateTime.UtcNow,
                            Score = deliverable.PercentDeliverables
                        };
                        _dbContext.Set<PgsDeliverableScoreHistory>().Add(history);
                    }
                    else
                    {
                        // New deliverable - Add to existing parent
                        existingPerfomanceGovernanceSystem.PgsDeliverables!.Add(deliverable);

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
}
