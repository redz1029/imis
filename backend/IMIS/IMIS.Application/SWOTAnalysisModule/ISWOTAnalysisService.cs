using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisModule
{
    public interface ISWOTAnalysisService : IService
    {
        Task<SWOTAnalysisDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<SWOTAnalysisDto>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken);
        public Task<DtoPageList<SWOTAnalysisDto, SWOTAnalysis, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
