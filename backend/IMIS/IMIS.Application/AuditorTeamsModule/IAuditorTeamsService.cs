
using Base.Pagination;
using IMIS.Application.PgsModule;
using IMIS.Domain;

namespace IMIS.Application.AuditorTeamsModule
{
    public interface IAuditorTeamsService
    {       
        Task<List<AuditorTeamsDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<AuditorTeamsDto> SaveOrUpdateAsync(AuditorTeamsDto auditorTeamsDto, CancellationToken cancellationToken);
        Task<List<AuditorTeamsDto>> GetAllAsyncFilterByTeamId(long? teamId, CancellationToken cancellationToken);       
    }
}
