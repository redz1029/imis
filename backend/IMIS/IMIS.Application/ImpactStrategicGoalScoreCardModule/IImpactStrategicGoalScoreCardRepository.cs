using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.ImpactStrategicGoalScoreCardModule
{
    public interface IImpactStrategicGoalScoreCardRepository : IRepository<ImpactStrategicGoalScoreCard, long>
    {
        Task<ImpactStrategicGoalScoreCard?> GetByIdWithChildrenAsync(long id, CancellationToken cancellationToken);
        Task<EntityPageList<ImpactStrategicGoalScoreCard, long>> GetPaginatedAsync(long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken);
    }
}
