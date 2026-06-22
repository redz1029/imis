using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.StrategyReviewModule
{
    public interface IStrategyReviewService : IService
    {
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<StrategyReviewDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<ReportStrategyReviewDto?> ReportGetByIdAsync(long id, CancellationToken cancellationToken);    
        Task<DtoPageList<StrategyReviewDto, StrategyReview, long>> GetAllRoleIdAsync(string roleId, int? strategyReviewPeriodId, int page, int pageSize, CancellationToken cancellationToken);
    }
}
