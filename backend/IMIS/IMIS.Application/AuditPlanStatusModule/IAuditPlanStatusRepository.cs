using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanStatusModule
{
    public interface IAuditPlanStatusRepository : IRepository<AuditPlanStatus, int>
    {
        Task<IEnumerable<AuditPlanStatus>?> GetAll(CancellationToken cancellationToken);

        Task<EntityPageList<AuditPlanStatus, int>> GetPaginatedAsync(int page, int pageSize,CancellationToken cancellationToken);
    }
}