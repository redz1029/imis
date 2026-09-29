using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.NonconformingActionReportModule
{
    public interface INcarRootCauseService : IService
    {
        Task<NcarRootCauseDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<bool> SaveRootCauseAsync(NcarRootCauseDto dto, CancellationToken cancellationToken);
        Task<DtoPageList<NcarRootCauseDto, NcarRootCause, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(long id, CancellationToken cancellationToken);
    }
}
