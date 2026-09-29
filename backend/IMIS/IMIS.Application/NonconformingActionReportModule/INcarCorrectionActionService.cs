using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.NonconformingActionReportModule
{
    public interface INcarCorrectionActionService : IService
    {
        Task<NcarCorrectionActionDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<bool> SaveCorrectionActionAsync(NcarCorrectionActionDto dto, CancellationToken cancellationToken);
        Task<DtoPageList<NcarCorrectionActionDto, NcarCorrectionAction, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(long id, CancellationToken cancellationToken);
    }
}
