using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.NonconformingActionReportModule
{
    public interface INcarCorrectionActionRepository : IRepository<NcarCorrectionAction, long>
    {
        Task<NcarCorrectionAction?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken);
        Task<EntityPageList<NcarCorrectionAction, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<NcarCorrectionAction?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken);
    }
}
