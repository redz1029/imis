using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanProcessModule
{
    public interface IAuditPlanProcessRepository : IRepository<AuditPlanProcess, int>
    {
        Task<EntityPageList<AuditPlanProcess, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanProcess>?> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanProcess>?> GetActiveAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanProcess>?> SearchByNameAsync(string name, CancellationToken cancellationToken);
        Task<AuditPlanProcess?> GetByNameAsync(string name, CancellationToken cancellationToken);
        Task<bool> ExistsByNameAsync(string name, int? excludeId = null, CancellationToken cancellationToken = default);

        // FIX 1: Change IsoStandard to AuditPlanProcess
        Task<AuditPlanProcess?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);

        // FIX 2: Add this so the Service can call it
        Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
    }
}