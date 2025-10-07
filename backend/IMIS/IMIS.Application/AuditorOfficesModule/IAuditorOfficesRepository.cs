using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditorOfficesModule
{
    public interface IAuditorOfficesRepository : IRepository<AuditorOffices, int>
    {
        Task<IEnumerable<AuditorOffices>?> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<AuditorOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<AuditorOffices?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
