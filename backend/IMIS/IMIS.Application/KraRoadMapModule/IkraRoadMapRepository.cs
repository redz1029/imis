using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapModule
{
    public interface IkraRoadMapRepository : IRepository<KraRoadMap, long>
    {
        Task<KraRoadMap?> GetByIdWithChildrenAsync(long id, CancellationToken cancellationToken = default);
        Task<IEnumerable<KraRoadMap>?> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<KraRoadMap, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<KraRoadMap?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<KraRoadMapFilter>>GetByKraYearAndDescriptionAsync(int kraId, int year, string kraDescription, bool isDirect, CancellationToken cancellationToken);
        Task<IEnumerable<KraRoadMapDescriptionFilter>> GetKraDescriptionsByKraIdAsync(int kraId, CancellationToken cancellationToken);
        Task<List<KraRoadMap>> GetAllForUserIdAsync(string roleid, CancellationToken cancellationToken);
        Task<List<KraRoadMapDeliverable>> GetDeliverablesAsync(int? kraid, int? fromYear, int? toYear, CancellationToken cancellationToken);
        Task<List<KraRoadMapDeliverable>> GetDeliverablesByRoleAsync(int? kraId, int? fromYear, int? toYear, string roleId, CancellationToken cancellationToken);
        Task<List<KraRoadMapKpi>> GetKpisAsync(int? kraid, int? fromYear, int? toYear, CancellationToken cancellationToken);  
        Task<List<KraRoadMapKpi>> GetKpisByRoleAsync(int? kraid, string roleId, int? fromYear, int? toYear, CancellationToken cancellationToken);


    }
}
