using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableAccomplishmentModule
{
    public interface IPgsDeliverableAccomplishmentRepository : IRepository<PgsDeliverableAccomplishment, long>
    {
        Task<List<PgsDeliverableAccomplishment>> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken);
    }
}
