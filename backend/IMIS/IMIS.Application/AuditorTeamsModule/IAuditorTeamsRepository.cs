using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.AuditorTeamsModule
{
    public interface IAuditorTeamsRepository : IRepository<AuditorTeams, int>
    {
        Task<IEnumerable<AuditorTeams>> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditorTeams>> GetAllAsyncFilterByTeamId(long? teamId, CancellationToken cancellationToken);
    }
}
