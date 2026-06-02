using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapAccomplishmentModule
{
    public interface IKraRoadmapAccomplishmentRepository : IRepository<KraRoadmapAccomplishment, long>
    {
        Task<List<KraRoadmapAccomplishment>> GetByDeliverableIdAsync(long kradeliverableId, CancellationToken cancellationToken);
    }
}
