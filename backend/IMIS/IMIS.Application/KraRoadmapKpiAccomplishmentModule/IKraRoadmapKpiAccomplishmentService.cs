using Base.Abstractions;

namespace IMIS.Application.KraRoadmapKpiAccomplishmentModule
{
    public interface IKraRoadmapKpiAccomplishmentService : IService
    {
        Task<List<KraRoadmapKpiAccomplishmentDto>> GetByKpiIdAsync(long kraKpiId, CancellationToken cancellationToken);
        Task<KraRoadmapKpiAccomplishmentDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
    }
}
