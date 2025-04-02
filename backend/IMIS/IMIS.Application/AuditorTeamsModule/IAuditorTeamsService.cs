
namespace IMIS.Application.AuditorTeamsModule
{
    public interface IAuditorTeamsService
    {
        Task<AuditorTeamsDto> SaveOrUpdateAsync(AuditorTeamsDto auditorTeamsDto, CancellationToken cancellationToken);       
    }
}
