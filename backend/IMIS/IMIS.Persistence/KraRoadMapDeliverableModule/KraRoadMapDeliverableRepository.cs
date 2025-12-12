using Base.Abstractions;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Domain;

namespace IMIS.Persistence.KraRoadMapDeliverableModule
{
    public class KraRoadMapDeliverableRepository : BaseRepository<KraRoadMapDeliverable, long, ImisDbContext>, IKraRoadMapDeliverableRepository
    {
        public KraRoadMapDeliverableRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
    }
}
