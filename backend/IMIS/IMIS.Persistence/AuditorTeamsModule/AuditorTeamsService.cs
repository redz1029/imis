using IMIS.Application.AuditorModule;
using IMIS.Domain;

namespace IMIS.Application.AuditorTeamsModule
{
    public class AuditorTeamsService : IAuditorTeamsService
    {
        private readonly IAuditorTeamsRepository _repository;
        public AuditorTeamsService(IAuditorTeamsRepository repository)
        {
            _repository = repository;
        }
     
        public async Task<List<AuditorTeamsDto>> GetAllAsync(CancellationToken cancellationToken)
        {
            var auditorTeams = await _repository.GetAllAsync(cancellationToken);
         
            var groupedAuditors = auditorTeams
                .GroupBy(at => at.TeamId)
                .Select(group => new AuditorTeamsDto
                {
                    TeamId = group.Key,
                    Auditors = group.Select(at => new AuditorDto
                    {
                        Id = at.Auditor!.Id,
                        Name = at.Auditor.Name,
                        IsTeamLeader = at.IsTeamLeader,
                        IsActive = at.Auditor.IsActive
                    }).ToList(),
                    IsActive = group.FirstOrDefault()?.IsActive ?? false
                })
                .ToList();
            return groupedAuditors;
        }

        public async Task<List<AuditorTeamsDto>> GetAllAsyncFilterByTeamId(long? teamId, CancellationToken cancellationToken)
        {
            var systems = await _repository.GetAllAsyncFilterByTeamId(teamId, cancellationToken).ConfigureAwait(false);
            var groupedAuditors = systems
               .GroupBy(at => at.TeamId)
               .Select(group => new AuditorTeamsDto
               {
                   TeamId = group.Key,
                   Auditors = group.Select(at => new AuditorDto
                   {
                       Id = at.Auditor!.Id,
                       Name = at.Auditor.Name,
                       IsTeamLeader = at.IsTeamLeader,
                       IsActive = at.Auditor.IsActive
                   }).ToList(),
                   IsActive = group.FirstOrDefault()?.IsActive ?? false
               })
               .ToList();
            return groupedAuditors;
            //return systems.Select(ConvPerfomanceGovernanceSystemToDTO).ToList();
        }
        // Save or update an auditor team
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
