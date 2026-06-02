using Base.Abstractions;
using IMIS.Application.KraRoadMapModule;

namespace IMIS.Application.KraRoadMapDeliverableModule
{
    public interface IKraRoadMapDeliverableService : IService
    {
        Task<List<FilterKraPeriodKraDeliverableDto>> GetByRoadMapIdAsync(long kraRoadMapId, int year, CancellationToken cancellationToken);
    }
}
