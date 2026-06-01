using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditComFindingsModule
{
    public interface IAuditComFindingsRepository : IRepository<AuditComFindings, int>
    {
        Task<AuditComFindings?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<AuditComFindings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<AuditComFindings?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken);
    }
}