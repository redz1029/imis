using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisModule
{
    public interface ISWOTAnalysisRepository : IRepository<SWOTAnalysis, int>
    {
        Task<List<SWOTAnalysis>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken);
        Task<List<SWOTAnalysis>> GetAllAsync(CancellationToken cancellationToken);
        Task<EntityPageList<SWOTAnalysis, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<SWOTAnalysis?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
