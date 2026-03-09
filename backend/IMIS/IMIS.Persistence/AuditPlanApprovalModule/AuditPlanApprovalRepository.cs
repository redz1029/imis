using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditPlanApprovalModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditPlanApprovalModule
{
    public class AuditPlanApprovalRepository(ImisDbContext dbContext) : BaseRepository<AuditPlanApproval, int, ImisDbContext, User>(dbContext), IAuditPlanApprovalRepository
    {
        public async Task<EntityPageList<AuditPlanApproval, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities
                .AsNoTracking()
                .Include(x => x.AuditPlan)
                .Include(x => x.Approver)
                .OrderByDescending(x => x.Timestamp);
            
            return await EntityPageList<AuditPlanApproval, int>.CreateAsync(query, page, pageSize, cancellationToken);
        }

        public async Task<IEnumerable<AuditPlanApproval>?> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.AuditPlan)
                .Include(x => x.Approver)
                .OrderByDescending(x => x.Timestamp)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<AuditPlanApproval>?> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.AuditPlan)
                .Include(x => x.Approver)
                .Where(x => x.AuditPlanId == auditPlanId)
                .OrderByDescending(x => x.Timestamp)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<AuditPlanApproval>?> GetByApproverIdAsync(int approverId, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.AuditPlan)
                .Include(x => x.Approver)
                .Where(x => x.ApproverId == approverId)
                .OrderByDescending(x => x.Timestamp)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<AuditPlanApproval>?> GetByActionAsync(string action, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.AuditPlan)
                .Include(x => x.Approver)
                .Where(x => x.Action == action)
                .OrderByDescending(x => x.Timestamp)
                .ToListAsync(cancellationToken);
        }

        public async Task<IEnumerable<AuditPlanApproval>?> GetByDateRangeAsync(DateTime startDate, DateTime endDate, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.AuditPlan)
                .Include(x => x.Approver)
                .Where(x => x.Timestamp >= startDate && x.Timestamp <= endDate)
                .OrderByDescending(x => x.Timestamp)
                .ToListAsync(cancellationToken);
        }

        public async Task<AuditPlanApproval?> GetByAuditPlanAndApproverAsync(int auditPlanId, int approverId, CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.AuditPlan)
                .Include(x => x.Approver)
                .FirstOrDefaultAsync(x => x.AuditPlanId == auditPlanId && x.ApproverId == approverId, cancellationToken);
        }

        public async Task<bool> ExistsByAuditPlanAndApproverAsync(int auditPlanId, int approverId, CancellationToken cancellationToken)
        {
            return await _entities
                .AnyAsync(x => x.AuditPlanId == auditPlanId && x.ApproverId == approverId, cancellationToken);
        }

        public async Task<AuditPlanApproval?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditPlanApproval>()
                .FirstOrDefaultAsync(sv => sv.Id == id, cancellationToken)
                .ConfigureAwait(false);
        } 
    }
    }
