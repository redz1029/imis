using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisModule
{
    public interface ISWOTAnalysisService : IService
    {
        Task<SWOTAnalysisDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<ReportSWOTAnalysisDto?> ReportGetByIdAsync(int id, CancellationToken cancellationToken);  
        Task<DtoPageList<SWOTAnalysisDto, SWOTAnalysis, long>?> GetPaginatedByUserIdAsync(string userId, int? officeId, int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<List<SWOTAnalysisDto>?> FilterByYearAsync(int year, int noOfResults, CancellationToken cancellationToken);
    }
}
