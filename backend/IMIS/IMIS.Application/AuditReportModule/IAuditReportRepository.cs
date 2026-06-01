using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditReportModule
{
    public interface IAuditReportRepository : IRepository<AuditReport, int>
    {
        Task<AuditReport?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<AuditReport, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<AuditReport?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken);
    }
}