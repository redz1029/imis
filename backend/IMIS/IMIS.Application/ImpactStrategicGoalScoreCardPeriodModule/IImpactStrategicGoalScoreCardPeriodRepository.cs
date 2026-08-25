using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule
{
    public interface IImpactStrategicGoalScoreCardPeriodRepository : IRepository<ImpactStrategicGoalScoreCardPeriod, int>
    {
        Task<IEnumerable<ImpactStrategicGoalScoreCardPeriod>> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<ImpactStrategicGoalScoreCardPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<ImpactStrategicGoalScoreCardPeriod?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
