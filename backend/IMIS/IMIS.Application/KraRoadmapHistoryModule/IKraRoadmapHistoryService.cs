using Base.Abstractions;

namespace IMIS.Application.KraRoadmapHistoryModule
{
    public interface IKraRoadmapHistoryService : IService
    {
        Task<List<KraRoadmapHistoryDto>?> GetAll(long? kraroadmapid, CancellationToken cancellationToken);
    }
}
