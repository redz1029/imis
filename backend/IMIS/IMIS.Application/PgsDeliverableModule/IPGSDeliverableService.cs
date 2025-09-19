using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Domain;
using Microsoft.AspNetCore.OutputCaching;

namespace IMIS.Application.PgsModule
{
    public interface IPGSDeliverableService : IService
    {       
        public Task<DtoPageList<PGSDeliverableDto, PgsDeliverable, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<PGSDeliverableDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<PGSDeliverableDto>?> GetAllAsync(CancellationToken cancellationToken); 
        Task<PGSDeliverableDto> SaveOrUpdateAsync(PGSDeliverableDto pgsDeliverableDto, CancellationToken cancellationToken);  
        Task<PgsDeliverableMonitorPageList> GetFilteredAsync(PgsDeliverableMonitorFilter filter, CancellationToken cancellationToken);
        Task<PgsDeliverableMonitorPageList> UpdateDeliverablesAsync(PgsDeliverableMonitorPageList request, IOutputCacheStore cache, CancellationToken cancellationToken);
    }
}






