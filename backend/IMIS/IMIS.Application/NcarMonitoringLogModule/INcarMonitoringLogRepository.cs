using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.NcarMonitoringLogModule
{
    public interface INcarMonitoringLogRepository : IRepository<NcarMonitoringLog, long>
    {
        Task<NcarMonitoringLog?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken);
        Task<EntityPageList<NcarMonitoringLog, long>> GetPaginatedSortedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<NcarMonitoringLog?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken);
        Task<NcarMonitoringLog?> GetByNonconformingActionReportIdAsync(long ncarId, CancellationToken cancellationToken);
        Task<int> GetNextSequenceAsync(int issuedYear, CancellationToken cancellationToken);
    }
}
