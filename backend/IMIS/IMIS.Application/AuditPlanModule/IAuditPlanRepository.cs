 using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditPlanModule
{
    public interface IAuditPlanRepository : IRepository<AuditPlan, int>
    {
        // Main retrieval
        Task<AuditPlan?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<AuditPlan?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);
        Task<AuditPlan?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlan>> GetAllAsync(CancellationToken cancellationToken);
        Task<EntityPageList<AuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // Child helpers
        Task<List<int>> GetExistingAuditPlanEntryIdsAsync(int auditPlanId, CancellationToken cancellationToken);
        Task<List<int>> GetExistingAuditPlanApprovalIdsAsync(int auditPlanId, CancellationToken cancellationToken);

        Task AddAuditPlanEntriesAsync(List<AuditPlanEntry> entries, CancellationToken cancellationToken);
        Task AddAuditPlanApprovalsAsync(List<AuditPlanApproval> approvals, CancellationToken cancellationToken);
    }
}