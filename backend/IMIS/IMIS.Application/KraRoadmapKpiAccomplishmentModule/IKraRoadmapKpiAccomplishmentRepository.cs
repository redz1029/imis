using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapKpiAccomplishmentModule
{
    public interface IKraRoadmapKpiAccomplishmentRepository : IRepository<KraRoadmapKpiAccomplishment, long>
    {
        Task<List<KraRoadmapKpiAccomplishment>> GetByKpiIdAsync(long kraKpiId, CancellationToken cancellationToken);
    }
}
