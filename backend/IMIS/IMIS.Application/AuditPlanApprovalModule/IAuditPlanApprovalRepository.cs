using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanApprovalModule
{
    public interface IAuditPlanApprovalRepository : IRepository<AuditPlanApproval, int>
    {
        Task<EntityPageList<AuditPlanApproval, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanApproval>?> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanApproval>?> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanApproval>?> GetByApproverIdAsync(int approverId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanApproval>?> GetByActionAsync(string action, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanApproval>?> GetByDateRangeAsync(DateTime startDate, DateTime endDate, CancellationToken cancellationToken);
        Task<AuditPlanApproval?> GetByAuditPlanAndApproverAsync(int auditPlanId, int approverId, CancellationToken cancellationToken);
        Task<bool> ExistsByAuditPlanAndApproverAsync(int auditPlanId, int approverId, CancellationToken cancellationToken);
        Task<AuditPlanApproval?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}