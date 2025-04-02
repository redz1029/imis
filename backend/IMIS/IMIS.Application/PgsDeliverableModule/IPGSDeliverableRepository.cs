using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace IMIS.Application.PgsModule
{
    public interface IPGSDeliverableRepository : IRepository<PgsDeliverable, long>
    {
        Task<EntityPageList<PgsDeliverable, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken); 
        Task<List<PgsDeliverable>?> GetAll(CancellationToken cancellationToken);
        new Task<PgsDeliverable> SaveOrUpdateAsync(PgsDeliverable pgsDeliverable, CancellationToken cancellationToken);
    }
}


