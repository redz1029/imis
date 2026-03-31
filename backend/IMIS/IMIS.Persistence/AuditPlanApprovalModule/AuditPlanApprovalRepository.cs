using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditPlanApprovalModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditPlanApprovalModule
{
    public class AuditPlanApprovalRepository(ImisDbContext dbContext)
        : BaseRepository<AuditPlanApproval, int, ImisDbContext, User>(dbContext), IAuditPlanApprovalRepository
    {
        public async Task<EntityPageList<AuditPlanApproval, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditPlanApproval, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditPlanApproval?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            // Accessing via ReadOnlyDbContext for efficiency during the check phase as per architectural pattern
            return await ReadOnlyDbContext.Set<AuditPlanApproval>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<AuditPlanApproval>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditPlanApproval?> GetWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.AuditPlan) // Assuming navigation property exists in Domain
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Filtered Query Implementations ---

        public async Task<IEnumerable<AuditPlanApproval>> FilterByAuditPlanId(int auditPlanId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.AuditPlanId == auditPlanId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanApproval>> FilterByApproverId(string approverId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                // Matching the DTO property 'AproverId' / Entity 'ApproverId' logic
                .Where(x => x.ApproverId == approverId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanApproval>> FilterByAction(string action, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.Action == action)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}