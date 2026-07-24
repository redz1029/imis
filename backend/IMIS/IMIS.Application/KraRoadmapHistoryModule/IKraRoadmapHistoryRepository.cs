using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapHistoryModule
{
    public interface IKraRoadmapHistoryRepository : IRepository<KraRoadmapHistory, long>
    {
        Task<IEnumerable<KraRoadmapHistory>?> GetAll(long? kraroadmapid, CancellationToken cancellationToken);
    }
}
