using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditNcarStatusModule
{
    public interface IAuditNcarStatusRepository : IRepository<AuditNcarStatus, int>
    {
        Task<AuditNcarStatus?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<AuditNcarStatus, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<AuditNcarStatus?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken);
    }
}