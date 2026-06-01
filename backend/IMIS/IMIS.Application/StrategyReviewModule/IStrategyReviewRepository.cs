using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.StrategyReviewModule
{
    public interface IStrategyReviewRepository : IRepository<StrategyReview, long>
    {
        Task<StrategyReview?> GetByIdWithChildrenAsync(long id,  CancellationToken cancellationToken);
        Task<List<string>> GetOfficeNamesByKraRoadMapIdAsync(long kraRoadMapId, CancellationToken cancellationToken);
    }
}
