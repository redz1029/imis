using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditStatusModule
{
    public interface IAuditStatusRepository : IRepository<AuditStatus, int>
    {
        Task<IEnumerable<AuditStatus>> GetAllAsync(CancellationToken cancellationToken);
        Task<AuditStatus?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<AuditStatus, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> IsInUseAsync(int id, CancellationToken cancellationToken);
    }
}