
using Base.Abstractions;

namespace IMIS.Application.AuditorTeamsModule
{
    public interface IAuditorTeamsService : IService
    {
        Task<List<AuditorTeamsDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<AuditorTeamsDto>> GetAllAsyncFilterByTeamId(long? teamId, CancellationToken cancellationToken);
    }
}
