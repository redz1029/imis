using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.StandardVersionModule
{
    public interface IStandardVersionRepository : IRepository<StandardVersion, int>
    {
        Task<IEnumerable<StandardVersion>> GetAll(CancellationToken cancellationToken);

        Task<EntityPageList<StandardVersion, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        Task<StandardVersion?> GetWithDetailsAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Filters standard versions based on their active status.
        /// </summary>
        Task<IEnumerable<StandardVersion>> FilterByActiveStatus(bool isActive, CancellationToken cancellationToken);

        /// <summary>
        /// Searches for standard versions by their name (e.g., for auto-complete or verification).
        /// </summary>
        Task<IEnumerable<StandardVersion>> FilterByVersionName(string versionName, CancellationToken cancellationToken);

        Task<StandardVersion?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}