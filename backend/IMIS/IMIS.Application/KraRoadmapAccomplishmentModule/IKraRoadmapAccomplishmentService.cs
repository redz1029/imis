using Base.Abstractions;
using IMIS.Application.PgsDeliverableAccomplishmentModule;

namespace IMIS.Application.KraRoadmapAccomplishmentModule
{
    public interface IKraRoadmapAccomplishmentService : IService
    {
        Task<List<KraRoadmapAccomplishmentDto>> GetByDeliverableIdAsync(long kradeliverableId, CancellationToken cancellationToken);
        Task<KraRoadmapAccomplishmentDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
    }
}
