using Base.Primitives;
using IMIS.Application.TeamModule;
using IMIS.Domain;

namespace IMIS.Persistence.TeamModule
{
    public class TeamService(ITeamRepository teamRepository) : ITeamService
    {
        private readonly ITeamRepository _teamRepository = teamRepository;

        public async Task<List<TeamDto>?> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            var teams = await _teamRepository.GetAllActiveAsync(cancellationToken).ConfigureAwait(false);
            return teams?.Select(t => new TeamDto()
            {
                Id = t.Id,
                Name = t.Name,
                IsActive = t.IsActive
            }).ToList();
        }

        public async Task<List<TeamDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var teams = await _teamRepository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            return teams?.Select(t => new TeamDto()
            {
                Id = t.Id,
                Name = t.Name,
                IsActive = t.IsActive
            }).ToList();
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var tDto = dto as TeamDto;
            var team = tDto?.ToEntity();
            if (team != null)
            {
                if (tDto?.Auditors?.Count > 0)
                {
                    List<AuditorTeams> auditorTeams = new List<AuditorTeams>();
                    foreach (var auditor in tDto.Auditors)
                    {
                        auditorTeams.Add(new AuditorTeams() { AuditorId = auditor.Id, TeamId = team.Id, IsTeamLeader = auditor.IsTeamLeader });
                    }
                }
                _teamRepository.Add(team);
                await _teamRepository.SaveOrUpdateAsync(team, cancellationToken).ConfigureAwait(false);
            }
        }
    }
}
