using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.NonconformingActionReportModule
{
    public interface INcarCorrectiveActionService : IService
    {
        Task<NcarCorrectiveActionDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<bool> SaveCorrectiveActionAsync(NcarCorrectiveActionDto dto, CancellationToken cancellationToken);
        Task<DtoPageList<NcarCorrectiveActionDto, NcarCorrectiveAction, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(long id, CancellationToken cancellationToken);
    }
}
