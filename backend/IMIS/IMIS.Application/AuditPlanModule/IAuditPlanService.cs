using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanModule
{
    public interface IAuditPlanService : IService
    {
        // Retrieval Operations
        Task<DtoPageList<AuditPlanDto, AuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<AuditPlanDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<AuditPlanDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<AuditPlanDto?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);
        Task<List<AuditPlanDto>?> GetByPreparerIdAsync(string preparerId, CancellationToken cancellationToken);
        Task<List<AuditPlanDto>?> GetByApproverIdAsync(string approverId, CancellationToken cancellationToken);
        Task<List<AuditPlanDto>?> GetByStatusAsync(string status, CancellationToken cancellationToken);
        Task<List<AuditPlanDto>?> GetByDateRangeAsync(DateTime startDate, DateTime endDate, CancellationToken cancellationToken);

        // Persistence Operations
        Task<AuditPlanDto> CreateAsync(AuditPlanDto auditPlanDto, CancellationToken cancellationToken);
        Task<AuditPlanDto> UpdateAsync(AuditPlanDto auditPlanDto, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        // Workflow & Business Logic
        Task<AuditPlanDto?> SubmitForApprovalAsync(int id, CancellationToken cancellationToken);
        Task<AuditPlanDto?> ApproveAsync(int id, string approverId, CancellationToken cancellationToken);
        Task<AuditPlanDto?> RejectAsync(int id, string approverId, string comments, CancellationToken cancellationToken);
    }
}