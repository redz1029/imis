using Base.Abstractions;
using IMIS.Application.PerformanceValidationToolModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PerformanceValidationToolModule
{
    public class PerformanceValidationToolRepository : BaseRepository<PerformanceValidationTool, long, ImisDbContext, User>, IPerformanceValidationToolRepository
    {
        public PerformanceValidationToolRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<PerformanceValidationTool?> GetByUserIdAndPerformanceValidationToolIdAsync(
        long performanceValidationToolId,
        CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Id == performanceValidationToolId)

                .Include(x => x.PerformanceValidationToolPeriod)

                .Include(x => x.PvtSignatories)

                .Include(x => x.Objectives)

                .Include(x => x.Conclusion)

                .Include(x => x.Validators)

                .Include(x => x.DeliverableFindings)

                .Include(x => x.Office)
                    .ThenInclude(x => x.UserOffices)

                .Include(x => x.Office)
                    .ThenInclude(x => x.ParentOffice)
                        .ThenInclude(x => x!.UserOffices)

                .FirstOrDefaultAsync(cancellationToken);
        }
        public async Task<PerformanceValidationTool?> GetWithIncludesAsync(
        long id,
        CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.Office)
                    .ThenInclude(x => x!.UserOffices)
                .Include(x => x.PerformanceValidationToolPeriod)
                .Include(x => x.PvtSignatories)
                .Include(x => x.Objectives)
                .Include(x => x.DeliverableFindings)
                .Include(x => x.Conclusion)
                .Include(x => x.Validators)
                .FirstOrDefaultAsync(
                    x => x.Id == id,
                    cancellationToken);
        }
        public async Task<IEnumerable<PerformanceValidationTool>?> GetAllPgsIdTool(long? performanceGovernanceSystemId, CancellationToken cancellationToken)
        {
            var query = _entities.AsNoTracking().AsQueryable();

            if (performanceGovernanceSystemId.HasValue)
            {
                query = query.Where(x => x.PerformanceGovernanceSystemId == performanceGovernanceSystemId);
            }
            return await query.ToListAsync(cancellationToken).ConfigureAwait(false);
        }

        public async Task<IEnumerable<PerformanceValidationTool>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
            .AsNoTracking()
            .ToListAsync(cancellationToken)
            .ConfigureAwait(false);
        }
        public async Task<PerformanceValidationTool?> GetByPvtIdAsync(long id, CancellationToken cancellationToken)
        {     
                 return await ReadOnlyDbContext.Set<PerformanceValidationTool>()
                .Include(x => x.PerformanceValidationToolPeriod)
                .Include(x => x.Office)
                .Include(x => x.OfficeHeadUser)
                .Include(x => x.Objectives)
                .Include(x => x.Conclusion)               
                .Include(x => x.Validators)
                    .ThenInclude(x => x.Auditor)
                    .ThenInclude(x => x.User)
                 .Include(x => x.DeliverableFindings)
                    .ThenInclude(x => x.PgsDeliverable)
                .Include(x => x.DeliverableFindings)
                .Include(x => x.PvtSignatories)
                    .ThenInclude(x => x.Signatory)
                .Include(x => x.PvtSignatories)

                .    ThenInclude(x => x.PerformanceValidationToolSignatoryTemplate)
                .FirstOrDefaultAsync(
                    x => x.Id == id,
                    cancellationToken);
        }
        

    }
}
