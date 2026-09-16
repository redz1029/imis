using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditStatusModule
{
    public interface IAuditPlanStatusRepository : IRepository<AuditPlanStatus, int>
    {
        Task<IEnumerable<AuditPlanStatus>> GetAllAsync(CancellationToken cancellationToken);
        Task<AuditPlanStatus?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<AuditPlanStatus, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> IsInUseAsync(int id, CancellationToken cancellationToken);
    }
}