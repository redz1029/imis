using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule
{
    public interface ISWOTAnalysisOpportunitiesThreatsSettingsRepository : IRepository<SWOTAnalysisOpportunitiesThreatsSettings, int>
    {
        Task<EntityPageList<SWOTAnalysisOpportunitiesThreatsSettings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<SWOTAnalysisOpportunitiesThreatsSettings>> GetAll(CancellationToken cancellationToken);
        Task<SWOTAnalysisOpportunitiesThreatsSettings?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
