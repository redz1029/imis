using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisServiceHeadModule
{
    public interface ISWOTAnalysisServiceHeadService : IService
    {
        Task<SWOTAnalysisServiceHeadDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<DtoPageList<SWOTAnalysisServiceHeadDto, SWOTAnalysisServiceHead, long>?> GetPaginatedByUserIdAsync(string userId, string roleId, int? officeId, int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
