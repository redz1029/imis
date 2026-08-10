using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.ImpactStrategicGoalScoreCardModule
{
    public interface IImpactStrategicGoalScoreCardService : IService
    {
        Task<ImpactStrategicGoalScoreCardDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<ImpactStrategicGoalScoreCardDto, ImpactStrategicGoalScoreCard, long>> GetPaginatedAsync(long? periodId, int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
