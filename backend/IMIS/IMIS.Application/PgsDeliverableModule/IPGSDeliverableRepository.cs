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
        Task<EntityPageList<PgsDeliverable, long>> GetFilteredAsync(PgsDeliverableMonitorFilter filter, CancellationToken cancellationToken);       
        Task<List<int>> GetUserOfficeIdsAsync(string userId, CancellationToken cancellationToken);
    }
}


