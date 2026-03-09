using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanModule
{
    public interface IAuditPlanRepository : IRepository<AuditPlan, int>
    {
        Task<EntityPageList<AuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlan>> GetAllAsync(CancellationToken cancellationToken);
        Task<AuditPlan?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlan>> GetByPreparerIdAsync(string preparerId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlan>> GetByApproverIdAsync(string approverId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlan>> GetByStatusAsync(string status, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlan>> GetByDateRangeAsync(DateTime startDate, DateTime endDate, CancellationToken cancellationToken);
        Task<AuditPlan?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}