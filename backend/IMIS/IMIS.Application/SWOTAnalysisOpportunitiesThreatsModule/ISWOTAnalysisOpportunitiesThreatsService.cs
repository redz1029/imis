using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule
{
    public interface ISWOTAnalysisOpportunitiesThreatsService : IService
    {
        public Task<DtoPageList<SWOTAnalysisOpportunitiesThreatsDto, SWOTAnalysisOpportunitiesThreats, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<SWOTAnalysisOpportunitiesThreatsDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<SWOTAnalysisOpportunitiesThreatsDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
