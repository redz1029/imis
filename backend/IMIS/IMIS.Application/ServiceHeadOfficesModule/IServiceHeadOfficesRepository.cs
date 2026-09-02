using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.ServiceHeadOfficesModule
{
    public interface IServiceHeadOfficesRepository : IRepository<ServiceHeadOffices, int>
    {
        Task<IEnumerable<ServiceHeadOffices>> GetAll(CancellationToken cancellationToken);
        Task<ServiceHeadOffices?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);
        Task<EntityPageList<ServiceHeadOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<ServiceHeadOffices?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
