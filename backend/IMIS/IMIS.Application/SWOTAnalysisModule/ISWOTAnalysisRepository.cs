using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisModule
{
    public interface ISWOTAnalysisRepository : IRepository<SWOTAnalysis, long>
    {      
        Task<EntityPageList<SWOTAnalysis, long>> GetPaginatedAllAsync(int? officeId, int page, int pageSize, CancellationToken cancellationToken);
        Task<EntityPageList<SWOTAnalysis, long>> GetPaginatedByUserIdAsync(string userId, int? officeId, int page, int pageSize, CancellationToken cancellationToken);
        Task<SWOTAnalysis?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<List<SWOTAnalysisDto>?> FilterByYearAsync(int year, int noOfResults, CancellationToken cancellationToken);
        Task<List<SWOTAnalysisDto>?> FilterByYearByUserAsync(string userId, int year, int noOfResults, CancellationToken cancellationToken);
        Task<SWOTAnalysis?> GetByIdWithChildrenAsync(int id, CancellationToken cancellationToken);
    }
}
