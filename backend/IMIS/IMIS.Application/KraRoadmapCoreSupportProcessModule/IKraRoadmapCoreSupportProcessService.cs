using Base.Abstractions;

namespace IMIS.Application.KraRoadmapCoreSupportProcessModule
{
    public interface IKraRoadmapCoreSupportProcessService : IService
    {
        Task<List<KraProcessGroupedDto>?> ReportGetByIdAsync(int kraRoadMapPeriodId, CancellationToken cancellationToken);
    }
}
