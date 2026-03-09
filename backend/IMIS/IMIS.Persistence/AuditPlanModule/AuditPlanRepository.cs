using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditPlanModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditPlanModule
{
    public class AuditPlanRepository(ImisDbContext dbContext)
        : BaseRepository<AuditPlan, int, ImisDbContext, User>(dbContext), IAuditPlanRepository
    {
        public async Task<EntityPageList<AuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .AsNoTracking()
                .Include(x => x.Preparer)
                .Include(x => x.SelectedApprover)
                .Include(x => x.Entries)
                .Include(x => x.Approvals)
                .OrderByDescending(x => x.CreatedDate);

            return await EntityPageList<AuditPlan, int>.CreateAsync(query, page, pageSize, cancellationToken);
        }

        public async Task<IEnumerable<AuditPlan>?> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.Preparer)
                .Include(x => x.SelectedApprover)
                .Include(x => x.Entries)
                .Include(x => x.Approvals)
                .ToListAsync(cancellationToken);
        }

        public async Task<AuditPlan?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            // Lightweight fetch for deletion using the ReadOnly context as per your pattern
            return await ReadOnlyDbContext.Set<AuditPlan>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<AuditPlan?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.Preparer)
                .Include(x => x.SelectedApprover)
                .Include(x => x.Entries)
                .Include(x => x.Approvals)
                    .ThenInclude(a => a.Approver) // Nested include for detailed approval history
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<AuditPlan>?> GetByPreparerIdAsync(string preparerId, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.Preparer)
                .Include(x => x.SelectedApprover)
                .Where(x => x.PreparerId == preparerId)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<AuditPlan>?> GetByApproverIdAsync(string approverId, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.Preparer)
                .Include(x => x.SelectedApprover)
                .Where(x => x.SelectedApproverId == approverId)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<AuditPlan>?> GetByStatusAsync(string planStatus, CancellationToken cancellationToken)
        {
            // Fixed naming: changed 'Status' variable to 'planStatus' to match parameter
            return await _entities
                .Include(x => x.Preparer)
                .Include(x => x.SelectedApprover)
                .Where(x => x.PlanStatus == planStatus)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<AuditPlan>?> GetByDateRangeAsync(DateTime startDate, DateTime endDate, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.Preparer)
                .Include(x => x.SelectedApprover)
                .Where(x => x.StartDate >= startDate && x.EndDate <= endDate)
                .ToListAsync(cancellationToken);
        }
    }
}