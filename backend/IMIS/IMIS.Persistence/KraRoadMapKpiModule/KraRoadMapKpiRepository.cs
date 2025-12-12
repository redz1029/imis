using Base.Abstractions;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Domain;

namespace IMIS.Persistence.KraRoadMapKpiModule
{
    public class KraRoadMapKpiRepository : BaseRepository<KraRoadMapKpi, int, ImisDbContext>, IKraRoadMapKpiRepository
    {
        public KraRoadMapKpiRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
    }
}
