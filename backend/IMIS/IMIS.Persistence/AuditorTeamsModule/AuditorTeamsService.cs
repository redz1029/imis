using IMIS.Application.AuditorTeamsModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditorTeamsModule
{
    public class AuditorTeamsService : IAuditorTeamsService
    {
        private readonly IAuditorTeamsRepository _repository;

        public AuditorTeamsService(IAuditorTeamsRepository repository)
        {
            _repository = repository;
        }
        
        public async Task<AuditorTeamsDto> SaveOrUpdateAsync(AuditorTeamsDto auditorTeamsDto, CancellationToken cancellationToken)
        {
            if (auditorTeamsDto == null)
                throw new ArgumentNullException(nameof(auditorTeamsDto));

            if (auditorTeamsDto.Auditors == null || !auditorTeamsDto.Auditors.Any())
                throw new ArgumentException("Auditor list cannot be null or empty.", nameof(auditorTeamsDto.Auditors));

            // Insert or update each auditor record individually
            foreach (var auditor in auditorTeamsDto.Auditors)
            {
                var auditorTeam = new AuditorTeams
                {
                    TeamId = auditorTeamsDto.TeamId,
                    AuditorId = auditor.Id,
                    IsTeamLeader = auditor.IsTeamLeader,
                    IsActive = auditorTeamsDto.IsActive
                };

                await _repository.SaveOrUpdateAsync(auditorTeam, cancellationToken);
            }
            return auditorTeamsDto;
        }

    }
}
