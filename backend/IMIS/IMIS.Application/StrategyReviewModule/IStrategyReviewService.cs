using Base.Abstractions;

namespace IMIS.Application.StrategyReviewModule
{
    public interface IStrategyReviewService : IService
    {
        Task<StrategyReviewDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<ReportStrategyReviewDto?> ReportGetByIdAsync(long id, CancellationToken cancellationToken);
        Task<List<StrategyReviewDto>?> GetAll(CancellationToken cancellationToken);
    }
}
