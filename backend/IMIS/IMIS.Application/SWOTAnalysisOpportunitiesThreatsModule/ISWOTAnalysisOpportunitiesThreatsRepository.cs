using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule
{
    public interface ISWOTAnalysisOpportunitiesThreatsRepository : IRepository<SWOTAnalysisOpportunitiesThreats, int>
    {
        Task<EntityPageList<SWOTAnalysisOpportunitiesThreats, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<SWOTAnalysisOpportunitiesThreats>> GetAll(CancellationToken cancellationToken);
        Task<SWOTAnalysisOpportunitiesThreats?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
