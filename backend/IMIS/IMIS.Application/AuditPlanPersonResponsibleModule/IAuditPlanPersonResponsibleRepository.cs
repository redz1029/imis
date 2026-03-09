using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanPersonResponsibleModule
{
    public interface IAuditPlanPersonResponsibleRepository : IRepository<AuditPlanPersonResponsible, int>
    {
        Task<EntityPageList<AuditPlanPersonResponsible, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanPersonResponsible>?> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanPersonResponsible>?> GetActiveAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanPersonResponsible>?> SearchByNameAsync(string name, CancellationToken cancellationToken);
        Task<AuditPlanPersonResponsible?> GetByNameAsync(string name, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanPersonResponsible>?> GetByPositionAsync(string position, CancellationToken cancellationToken);
        Task<bool> ExistsByNameAsync(string name, int? excludeId = null, CancellationToken cancellationToken = default);
        Task<AuditPlanPersonResponsible?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}