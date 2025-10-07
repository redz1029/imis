using Base.Primitives;
using IMIS.Application.TeamModule;
using IMIS.Domain;
using IMIS.Application.AuditorModule;
using Base.Pagination;
using Base.Abstractions;


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
                    Id = a.AuditorId ?? 0,
                    IsActive = a.Auditor!.IsActive,
                    Name = a.Auditor!.Name,
                    UserId = a.Auditor!.UserId,
                    
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
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var teams = await _teamRepository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (teams == null)
                return false;

            teams.IsDeleted = true;

            var context = _teamRepository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
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
                            Id = 0,
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
                await _teamRepository.SaveOrUpdateAsync<User>(team, cancellationToken).ConfigureAwait(false);
            }
        }         
    }
}
