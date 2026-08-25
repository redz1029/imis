using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule
{
    public interface ISWOTAnalysisOpportunitiesThreatsSettingsService : IService
    {
        public Task<DtoPageList<SWOTAnalysisOpportunitiesThreatsSettingsDto, SWOTAnalysisOpportunitiesThreatsSettings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<SWOTAnalysisOpportunitiesThreatsSettingsDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<SWOTAnalysisOpportunitiesThreatsSettingsDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
