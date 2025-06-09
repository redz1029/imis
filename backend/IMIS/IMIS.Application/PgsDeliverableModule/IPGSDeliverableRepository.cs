using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPGSDeliverableRepository : IRepository<PgsDeliverable, long>
    {
        Task<EntityPageList<PgsDeliverable, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken); 
        Task<List<PgsDeliverable>?> GetAll(CancellationToken cancellationToken);
        new Task<PgsDeliverable> SaveOrUpdateAsync(PgsDeliverable pgsDeliverable, CancellationToken cancellationToken);
        Task<EntityPageList<PgsDeliverable, long>> GetFilteredAsync(PgsDeliverableMonitorFilter filter, CancellationToken cancellationToken);
    }
}


