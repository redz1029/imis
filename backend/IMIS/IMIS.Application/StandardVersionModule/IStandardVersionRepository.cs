using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.StandardVersionModule
{
    public interface IStandardVersionRepository : IRepository<StandardVersion, int>
    {
        Task<IEnumerable<StandardVersion>> GetAll(CancellationToken cancellationToken);
        Task<IEnumerable<StandardVersion>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);
        Task<EntityPageList<StandardVersion, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<StandardVersion?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<StandardVersion?> GetByIdWithIsoStandardsAsync(int id, CancellationToken cancellationToken);
    }
}
