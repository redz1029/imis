using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapDeliverableModule
{
    public interface IKraRoadMapDeliverableRepository   : IRepository<KraRoadMapDeliverable, long>
    {
        Task<List<KraRoadMapDeliverable>> GetByRoadMapIdAsync(long kraRoadMapId, int year, CancellationToken cancellationToken);
        Task<List<(long KraRoadMapId, DateTime StartYear, DateTime EndYear)>> GetRoadMapPeriodsAsync(List<KraRoadMapDeliverable> deliverables, CancellationToken cancellationToken);        
        Task<List<KraRoadMapDeliverable>> GetDeliverablesByIdsAsync(List<long> ids, CancellationToken cancellationToken);
    }
}