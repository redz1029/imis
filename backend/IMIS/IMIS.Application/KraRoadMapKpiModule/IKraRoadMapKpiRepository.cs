using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapKpiModule
{
    public interface IKraRoadMapKpiRepository : IRepository<KraRoadMapKpi, int>
    {
        Task<List<KraRoadMapKpi>> GetKpisByRoadMapIdAsync(long kraRoadMapId, int year, CancellationToken cancellationToken);
        Task<List<(long KraRoadMapId, DateTime StartYear, DateTime EndYear)>> GetRoadMapPeriodsForKpisAsync(List<KraRoadMapKpi> kpis, CancellationToken cancellationToken);
        Task<List<KraRoadMapKpi>> GetKpisByIdsAsync(List<long> ids, CancellationToken cancellationToken);
    }
}
