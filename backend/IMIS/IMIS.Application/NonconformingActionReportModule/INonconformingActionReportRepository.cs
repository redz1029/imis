using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.NonconformingActionReportModule
{
    public interface INonconformingActionReportRepository : IRepository<NonconformingActionReport, long>
    {
        Task<NonconformingActionReport?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken);
        Task<EntityPageList<NonconformingActionReport, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<NonconformingActionReport?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken);
        Task<NonconformingActionReport?> GetByAuditReportIdAsync(int auditReportId, CancellationToken cancellationToken);
    }
}
