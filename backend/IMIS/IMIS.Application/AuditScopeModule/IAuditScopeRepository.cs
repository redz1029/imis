using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditScopeModule
{
    public interface IAuditScopeRepository : IRepository<AuditScope, int>
    {
        Task<AuditScope?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<AuditScope, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<AuditScope?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken);
    }
}