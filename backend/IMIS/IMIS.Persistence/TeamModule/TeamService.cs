using Base.Primitives;
using IMIS.Application.TeamModule;
using IMIS.Domain;
using Base.Pagination;

namespace IMIS.Persistence.TeamModule
{
    public class TeamService(ITeamRepository teamRepository) : ITeamService
    {
        private readonly ITeamRepository _teamRepository = teamRepository;
      
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
            return team != null ? new TeamDto(team) : null;
        }       
        public async Task<List<TeamDto>?> FilterByName(string name, int teamNoOfResults, CancellationToken cancellationToken)
        {
            var teams = await _teamRepository.FilterByName(name, teamNoOfResults, cancellationToken).ConfigureAwait(false);

            if (teams == null || !teams.Any())
                return null;

            return teams.Select(a => new TeamDto(a)).ToList();
        }
        public async Task<List<TeamDto>?> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            var teams = await _teamRepository.GetAllActiveAsync(cancellationToken).ConfigureAwait(false);
            if (teams == null)
                return null;

            return teams.Select(d => new TeamDto(d)).ToList();
        }
        public async Task<List<TeamDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var teams = await _teamRepository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            if (teams == null)
                return null;

            return teams.Select(d => new TeamDto(d)).ToList();
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
                            IsTeamLeader = auditor.IsTeamLeader,
                            ImprovementType = auditor.ImprovementType

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
