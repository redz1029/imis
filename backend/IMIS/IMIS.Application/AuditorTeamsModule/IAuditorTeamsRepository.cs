using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditorTeamsModule
{
    public interface IAuditorTeamsRepository : IRepository<AuditorTeams, int>
    {
        Task<IEnumerable<AuditorTeams>> GetAllAsync(CancellationToken cancellationToken);
        Task<List<AuditorTeams>> GetByTeamIdAsync(long teamId, CancellationToken cancellationToken);
        Task<EntityPageList<AuditorTeams, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
