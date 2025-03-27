using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.TeamModule
{
    public interface ITeamRepository : IRepository<Team, int>
    {
        Task<EntityPageList<Team, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<Team>> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<Team>> GetAllActiveAsync(CancellationToken cancellationToken);
        new Task<Team> SaveOrUpdateAsync(Team Team, CancellationToken cancellationToken);
        Task<IEnumerable<Team>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);

    }
}
