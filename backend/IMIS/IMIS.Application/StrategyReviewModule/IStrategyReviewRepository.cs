using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.StrategyReviewModule
{
    public interface IStrategyReviewRepository : IRepository<StrategyReview, long>
    {
        Task<StrategyReview?> GetByIdWithChildrenAsync(long id,  CancellationToken cancellationToken);
        Task<List<string>> GetOfficeNamesByKraIdAsync(long kraId, DateOnly reviewStartDate, DateOnly reviewEndDate, CancellationToken cancellationToken);
        Task<List<StrategyReview>> GetAll(CancellationToken cancellationToken);
        Task<List<StrategyReview>> GetAllForRoleAsync(string roleId, CancellationToken cancellationToken);
        Task<StrategyReview?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
