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
        public async Task<bool> SoftDeleteAsync(int teamId, CancellationToken cancellationToken)
        {           
            var teamMembers = await _repository.GetByTeamIdAsync(teamId, cancellationToken).ConfigureAwait(false);

            if (!teamMembers.Any())
                return false;
            
            foreach (var member in teamMembers)
            {
                member.IsDeleted = true;
                member.IsActive = false;
            }

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken)
                .ConfigureAwait(false);

            return true;
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
                            ImprovementType = at.Auditor.ImprovementType

                        })
                        .ToList(),
                    IsActive = group.FirstOrDefault()?.IsActive ?? false
                })
                .ToList();

            return groupedAuditors;
        }        
        public async Task<AuditorTeamsDto?> GetByTeamIdAsync(long teamId, CancellationToken cancellationToken)
        {
            var auditorTeams = await _repository.GetByTeamIdAsync(teamId, cancellationToken).ConfigureAwait(false);

            if (auditorTeams == null || !auditorTeams.Any())
                return null;

            var group = auditorTeams.First().TeamId;

            var dto = new AuditorTeamsDto
            {
                Id = auditorTeams.First().Id,
                TeamId = group,
                Auditors = auditorTeams
                    .Where(at => at.Auditor != null)
                    .Select(at => new AuditorDto
                    {
                        Id = at.Auditor!.Id,
                        Name = at.Auditor.Name,
                        IsTeamLeader = at.IsTeamLeader,
                        IsActive = at.Auditor.IsActive,
                        UserId = at.Auditor.UserId,
                        ImprovementType = at.Auditor.ImprovementType
                    })
                    .ToList(),
                IsActive = auditorTeams.First().IsActive
            };

            return dto;
        }        
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var oDto = dto as AuditorTeamsDto;
            if (oDto == null)
                throw new ArgumentException("Invalid DTO type. Expected AuditorTeamsDto.");

            var context = _repository.GetDbContext();
          
            var auditorTeamEntity = oDto.ToEntity();
          
            var existingTeams = await _repository.GetByTeamIdAsync(auditorTeamEntity.TeamId, cancellationToken).ConfigureAwait(false);

            if (existingTeams.Any())
            {
                context.RemoveRange(existingTeams);
            }
           
            if (oDto.Auditors != null && oDto.Auditors.Any())
            {
                foreach (var auditorDto in oDto.Auditors)
                {
                    var newTeam = new AuditorTeams
                    {
                        Id = 0,
                        TeamId = auditorTeamEntity.TeamId,       
                        AuditorId = auditorDto.Id,               
                        IsTeamLeader = auditorDto.IsTeamLeader,
                        IsActive = auditorTeamEntity.IsActive
                    };

                    await context.AddAsync(newTeam, cancellationToken).ConfigureAwait(false);
                }
            }

            await context.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
        }
    }
}
