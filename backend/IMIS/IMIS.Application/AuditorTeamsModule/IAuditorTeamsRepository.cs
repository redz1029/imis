using IMIS.Domain;

namespace IMIS.Application.AuditorTeamsModule
{
    public interface IAuditorTeamsRepository
    {
        Task<AuditorTeams> SaveOrUpdateAsync(AuditorTeams period, CancellationToken cancellationToken);       
    }
}
