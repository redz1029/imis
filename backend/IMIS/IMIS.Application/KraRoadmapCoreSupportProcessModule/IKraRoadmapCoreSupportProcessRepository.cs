using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapCoreSupportProcessModule
{
    public interface IKraRoadmapCoreSupportProcessRepository : IRepository<KraRoadmapCoreSupportProcess, int>
    {
        Task<List<KraProcessGroupedDto>> GetGroupedAsync(int kraRoadMapPeriodId, CancellationToken cancellationToken);
        Task<Dictionary<int, string?>> GetProcessNamesAsync(List<int> processIds, CancellationToken cancellationToken);
    }
}
