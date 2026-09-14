using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanApprovalModule
{
    public interface IAuditPlanApprovalRepository : IRepository<AuditPlanApproval, int>
    {
        /// <summary>
        /// Retrieves a paginated list of Audit Plan Approvals.
        /// </summary>
        Task<EntityPageList<AuditPlanApproval, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        /// <summary>
        /// Specialized lookup for soft delete operations using the ReadOnly context.
        /// </summary>
        Task<AuditPlanApproval?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves all approvals, typically used for lists where pagination isn't required.
        /// </summary>
        Task<IEnumerable<AuditPlanApproval>> GetAll(CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves an approval with its related navigation properties (e.g., AuditPlan).
        /// </summary>
        Task<AuditPlanApproval?> GetWithDetailsAsync(int id, CancellationToken cancellationToken);

        // --- Filtered Query Definitions ---

        /// <summary>
        /// Filters approvals associated with a specific Audit Plan.
        /// </summary>
        Task<IEnumerable<AuditPlanApproval>> FilterByAuditPlanId(int auditPlanId, CancellationToken cancellationToken);

        /// <summary>
        /// Filters approvals performed by a specific user.
        /// </summary>
        Task<IEnumerable<AuditPlanApproval>> FilterByApproverId(string approverId, CancellationToken cancellationToken);

        /// <summary>
        /// Filters approvals by the action taken (e.g., "Approved", "Rejected").
        /// </summary>
        Task<IEnumerable<AuditPlanApproval>> FilterByAction(string action, CancellationToken cancellationToken);
    }
}