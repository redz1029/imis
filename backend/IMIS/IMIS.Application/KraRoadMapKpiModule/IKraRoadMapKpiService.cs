using Base.Abstractions;
using IMIS.Application.KraRoadMapModule;

namespace IMIS.Application.KraRoadMapKpiModule
{
    public interface IKraRoadMapKpiService : IService
    {
        Task<List<KraRoadMapKpiDeliverableFilterDto>> GetKpiByRoadMapIdAsync(long kraRoadMapId, int year, CancellationToken cancellationToken);
    }
}
