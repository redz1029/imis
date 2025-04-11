using IMIS.Application.AuditorModule;
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

        private AuditorTeamsDto ConvOfficeToDTO(AuditorTeams auditorTeams)
        {
            if (auditorTeams == null) return null;

            return new AuditorTeamsDto
            {
                TeamId = auditorTeams.TeamId,
                Auditors = auditorTeams.Auditor != null
                    ? new List<AuditorDto>
                    {
                        new AuditorDto
                        {
                            Id = auditorTeams.Auditor.Id,
                            Name = auditorTeams.Auditor.Name,
                            IsTeamLeader = auditorTeams.IsTeamLeader,
                            IsActive = auditorTeams.Auditor.IsActive
                        }
                    }
                    : new List<AuditorDto>(),
                IsActive = auditorTeams.IsActive
            };
        }
        public async Task<List<AuditorTeamsDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var auditorTeamsDto = await _repository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            return auditorTeamsDto?.Select(o => ConvOfficeToDTO(o)).ToList();
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
