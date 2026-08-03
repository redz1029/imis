using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule
{
    public interface IImpactStrategicGoalScoreCardPeriodService : IService
    {
        Task<List<ImpactStrategicGoalScoreCardPeriodDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<ImpactStrategicGoalScoreCardPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<ImpactStrategicGoalScoreCardPeriodDto, ImpactStrategicGoalScoreCardPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
