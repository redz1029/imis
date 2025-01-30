using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.TeamModule
{
    public interface ITeamRepository : IRepository<Team, int>
    {
        Task<IEnumerable<Team>> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<Team>> GetAllActiveAsync(CancellationToken cancellationToken);
    }
}
