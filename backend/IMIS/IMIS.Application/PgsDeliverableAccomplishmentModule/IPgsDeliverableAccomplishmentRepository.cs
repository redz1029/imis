using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableAccomplishmentModule
{
    public interface IPgsDeliverableAccomplishmentRepository : IRepository<PgsDeliverableAccomplishment, long>
    {
        Task<List<PgsDeliverableAccomplishment>> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken);
        Task<EntityPageList<PgsDeliverableAccomplishment, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
