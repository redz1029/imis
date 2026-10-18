using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.NonconformingActionReportModule
{
    public interface INcarRootCauseRepository : IRepository<NcarRootCause, long>
    {
        Task<NcarRootCause?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken);
        Task<EntityPageList<NcarRootCause, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<NcarRootCause?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken);
    }
}
