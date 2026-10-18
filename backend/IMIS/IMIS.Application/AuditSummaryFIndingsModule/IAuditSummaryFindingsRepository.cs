using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditSummaryFindingsModule
{
    public interface IAuditSummaryFindingsRepository : IRepository<AuditSummaryFIndings, int>
    {
        Task<AuditSummaryFIndings?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<AuditSummaryFIndings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<AuditSummaryFIndings?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken);
    }
}