using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisServiceHeadModule
{
    public interface ISWOTAnalysisServiceHeadRepository : IRepository<SWOTAnalysisServiceHead, long>
    {
        Task<SWOTAnalysisServiceHead?> GetByIdWithChildrenAsync(int id, CancellationToken cancellationToken);
        Task<SWOTAnalysisServiceHead?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<SWOTAnalysisServiceHead, long>> GetPaginatedAllAsync(int? officeId, int page, int pageSize, CancellationToken cancellationToken);
        Task<EntityPageList<SWOTAnalysisServiceHead, long>> GetPaginatedByUserIdAsync(string userId, int? officeId, int page, int pageSize, CancellationToken cancellationToken);
    }
}
