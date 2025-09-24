using Base.Pagination;
using Base.Primitives;
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

        public async Task<DtoPageList<AuditorTeamsDto, AuditorTeams, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var auditorTeams = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (auditorTeams.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<AuditorTeamsDto, AuditorTeams, int>.Create(auditorTeams.Items, page, pageSize, auditorTeams.TotalCount);
        }

        public async Task<List<AuditorTeamsDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var auditorTeams = await _repository.GetAllAsync(cancellationToken);

            var groupedAuditors = auditorTeams
                .GroupBy(at => at.TeamId)
                .Select(group => new AuditorTeamsDto
                {
                    Id = group.Key,
                    TeamId = group.Key,
                    Auditors = group
                        .Where(at => at.Auditor != null)
                        .Select(at => new AuditorDto
                        {
                            Id = at.Auditor!.Id,
                            Name = at.Auditor.Name,
                            IsTeamLeader = at.IsTeamLeader,
                            IsActive = at.Auditor.IsActive,
                            UserId = at.Auditor.UserId,
                        })
                        .ToList(),
                    IsActive = group.FirstOrDefault()?.IsActive ?? false
                })
                .ToList();

            return groupedAuditors;
        }


        public async Task<List<AuditorTeamsDto>> GetAllAsyncFilterByTeamId(long? teamId, CancellationToken cancellationToken)
        {          
            var auditorTeams = await _repository.GetAllAsyncFilterByTeamId(teamId, cancellationToken)
                .ConfigureAwait(false);
          
            var groupedAuditors = auditorTeams
                .GroupBy(at => at.TeamId)
                .Select(group => new AuditorTeamsDto
                {
                    Id = group.First().Id,
                    TeamId = group.Key,
                    Auditors = group
                        .Where(at => at.Auditor != null)
                        .Select(at => new AuditorDto
                        {
                            Id = at.Auditor!.Id,
                            Name = at.Auditor.Name,
                            IsTeamLeader = at.IsTeamLeader,
                            IsActive = at.Auditor.IsActive,
                            UserId= at.Auditor.UserId,
                        })
                        .ToList(),
                    IsActive = group.Any() ? group.First().IsActive : false
                })
                .ToList();

            return groupedAuditors;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as AuditorTeamsDto;
            var auditorTeamEntity = ODto!.ToEntity();
          
            if (ODto.Auditors != null && ODto.Auditors.Any())
            {
                foreach (var auditorDto in ODto.Auditors)
                {
                    var auditorTeam = new AuditorTeams
                    {
                        Id = 0,
                        TeamId = auditorTeamEntity.TeamId,
                        AuditorId = auditorDto.Id,
                        IsTeamLeader = auditorDto.IsTeamLeader,
                        IsActive = auditorTeamEntity.IsActive
                    };
                    await _repository.GetDbContext().AddAsync(auditorTeam, cancellationToken).ConfigureAwait(false);
                }
            }
           
            if (auditorTeamEntity.Id != 0)
            {
                await _repository.UpdateAsync(auditorTeamEntity, auditorTeamEntity.Id, cancellationToken).ConfigureAwait(false);
            }

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);
        }
    }
}
