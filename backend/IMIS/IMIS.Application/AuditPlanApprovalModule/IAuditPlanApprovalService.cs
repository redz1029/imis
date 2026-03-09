using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanApprovalModule
{
    public interface IAuditPlanApprovalService : IService
    {
        // =====================================================
        // GET
        // =====================================================

        Task<DtoPageList<AuditPlanApprovalDto, AuditPlanApproval, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken = default);

        Task<List<AuditPlanApprovalDto>> GetAllAsync(CancellationToken cancellationToken = default);

        Task<AuditPlanApprovalDto?> GetByIdAsync(int id, CancellationToken cancellationToken = default);

        Task<List<AuditPlanApprovalDto>> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken = default);

        Task<List<AuditPlanApprovalDto>> GetByApproverIdAsync(int approverId, CancellationToken cancellationToken = default);

        Task<List<AuditPlanApprovalDto>> GetByActionAsync(string action, CancellationToken cancellationToken = default);

        Task<List<AuditPlanApprovalDto>> GetByDateRangeAsync(DateTime startDate, DateTime endDate, CancellationToken cancellationToken = default);

        Task<AuditPlanApprovalDto?> GetByAuditPlanAndApproverAsync(int auditPlanId, int approverId, CancellationToken cancellationToken = default);

        // =====================================================
        // CREATE (STRICT ACTION CONTROLLED IN SERVICE)
        // =====================================================

        Task<AuditPlanApprovalDto>CreateApprovalAsync(int auditPlanId, int approverId, string action, string? comments = null, CancellationToken cancellationToken = default);

        

        // =====================================================
        // WORKFLOW ACTIONS
        // =====================================================

        Task<AuditPlanApprovalDto?>ApproveAuditPlanAsync(int auditPlanId, int approverId, string? comments = null, CancellationToken cancellationToken = default);

        Task<AuditPlanApprovalDto?> RejectAuditPlanAsync(int auditPlanId, int approverId, string comments, CancellationToken cancellationToken = default);

        Task<AuditPlanApprovalDto?>ReviewAuditPlanAsync(int auditPlanId, int approverId, string? comments = null, CancellationToken cancellationToken = default);

        // =====================================================
        // DELETE
        // =====================================================

        Task<bool>SoftDeleteAsync(int id, CancellationToken cancellationToken = default);

        // =====================================================
        // EXISTS
        // =====================================================

        Task<bool> ExistsByAuditPlanAndApproverAsync(int auditPlanId, int approverId, CancellationToken cancellationToken = default);
    }
}