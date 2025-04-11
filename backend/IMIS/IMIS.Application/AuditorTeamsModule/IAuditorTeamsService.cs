
using IMIS.Application.AuditScheduleModule;

namespace IMIS.Application.AuditorTeamsModule
{
    public interface IAuditorTeamsService
    {
        Task<List<AuditorTeamsDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<AuditorTeamsDto> SaveOrUpdateAsync(AuditorTeamsDto auditorTeamsDto, CancellationToken cancellationToken);
      
    }
}
