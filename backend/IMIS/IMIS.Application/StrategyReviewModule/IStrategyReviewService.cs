using Base.Abstractions;

namespace IMIS.Application.StrategyReviewModule
{
    public interface IStrategyReviewService : IService
    {
        Task<StrategyReviewDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
    }
}
