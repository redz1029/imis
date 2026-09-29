using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.NonconformingActionReportModule
{
    public interface INcarCorrectiveActionRepository : IRepository<NcarCorrectiveAction, long>
    {
        Task<NcarCorrectiveAction?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken);
        Task<EntityPageList<NcarCorrectiveAction, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<NcarCorrectiveAction?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken);
    }
}
