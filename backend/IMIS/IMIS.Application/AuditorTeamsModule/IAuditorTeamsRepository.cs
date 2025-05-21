using IMIS.Domain;

namespace IMIS.Application.AuditorTeamsModule
{
    public interface IAuditorTeamsRepository
    {
        Task<AuditorTeams> SaveOrUpdateAsync(AuditorTeams period, CancellationToken cancellationToken);
        Task<IEnumerable<AuditorTeams>> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditorTeams>> GetAllAsyncFilterByTeamId(long? teamId, CancellationToken cancellationToken);       
    }
}
