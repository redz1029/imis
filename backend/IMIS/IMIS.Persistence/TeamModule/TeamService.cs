using Base.Primitives;
using IMIS.Application.TeamModule;
using IMIS.Domain;
using IMIS.Application.AuditorModule;
using Base.Pagination;


namespace IMIS.Persistence.TeamModule
{
    public class TeamService(ITeamRepository teamRepository) : ITeamService
    {
        private readonly ITeamRepository _teamRepository = teamRepository;
        private static TeamDto ConvTeamToDto(Team team)
        {
            return new TeamDto()
            {
                Id = team.Id,
                Name = team.Name,
                IsActive = team.IsActive,
                Auditors = team.AuditorTeams?.Select(a => new AuditorDto()
                {
                    Id = a.AuditorId,
                    IsActive = a.Auditor!.IsActive,
                    Name = a.Auditor!.Name
                }).ToList(),
            };
        }
        public async Task<DtoPageList<TeamDto, Team, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var team = await _teamRepository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (team.TotalCount == 0)
                return null;
            return DtoPageList<TeamDto, Team, int>.Create(team.Items, page, pageSize, team.TotalCount);
        }
        public async Task<TeamDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var team = await _teamRepository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return team != null ? ConvTeamToDto(team) : null;
        }
        public async Task<List<TeamDto>?> FilterByName(string name, int teamNoOfResults, CancellationToken cancellationToken)
        {
            var team = await _teamRepository.FilterByName(name, teamNoOfResults, cancellationToken).ConfigureAwait(false);
            return team != null && team.Count() > 0 ? team.Select(a => ConvTeamToDto(a)).ToList() : null;
        }
        public async Task<List<TeamDto>?> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            var teams = await _teamRepository.GetAllActiveAsync(cancellationToken).ConfigureAwait(false);
            return teams?.Select(t => ConvTeamToDto(t)).ToList();
        }
        public async Task<List<TeamDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var teams = await _teamRepository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            return teams?.Select(t => ConvTeamToDto(t)).ToList();
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var teamDto = dto as TeamDto;
            var team = teamDto?.ToEntity();
            if (team != null)
            {
                if (teamDto?.Auditors?.Count > 0)
                {
                    List<AuditorTeams> auditorTeams = [];
                    foreach (var auditor in teamDto.Auditors)
                    {
                        auditorTeams.Add(new AuditorTeams() 
                        { 
                            AuditorId = auditor.Id, 
                            TeamId = team.Id, 
                            IsTeamLeader = auditor.IsTeamLeader 
                        });
                    }
                }
                if(team.Id == 0)
                {
                    _teamRepository.Add(team);
                } else
                {
                    await _teamRepository.UpdateAsync(team, team.Id, cancellationToken).ConfigureAwait(false);
                }
                await _teamRepository.SaveOrUpdateAsync(team, cancellationToken).ConfigureAwait(false);
            }
        }
        public async Task<TeamDto> SaveOrUpdateAsync(TeamDto teamDto, CancellationToken cancellationToken)
        {
            if (teamDto == null) throw new ArgumentNullException(nameof(TeamDto));
            var teamEntity = teamDto.ToEntity();
            var createdTeam = await _teamRepository.SaveOrUpdateAsync(teamEntity, cancellationToken).ConfigureAwait(false);
            return new TeamDto
            {
                Id = createdTeam.Id,
                Name = createdTeam.Name,
                IsActive = createdTeam.IsActive
            };
        }      
    }
}
