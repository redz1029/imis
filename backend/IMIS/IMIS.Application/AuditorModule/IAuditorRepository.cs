using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditorModule
{
    public interface IAuditorRepository : IRepository<Auditor, int>
    {
        Task<EntityPageList<Auditor, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<Auditor>?> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<Auditor, int>> FilterByNameAsync(string name, int page, int pageSize, CancellationToken cancellationToken);
        Task<Auditor?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<Team?> GetTeamByUserIdAsync(string userId, CancellationToken cancellationToken);

    }
}
