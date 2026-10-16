using Base.Primitives;
using IMIS.Application.AuditorModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Application.AuditorTeamsModule
{
    public class AuditorTeamsService : IAuditorTeamsService 
    {
        private readonly IAuditorTeamsRepository _repository;
        private readonly UserManager<User> _userManager;
        public AuditorTeamsService(IAuditorTeamsRepository repository, UserManager<User> userManager)
        {
            _repository = repository;
            _userManager = userManager;
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

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return true;
        }
    
        public async Task<AuditorTeamsPageDto> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var auditorTeams = await _repository.GetAllAsync(cancellationToken);

            foreach (var auditorTeam in auditorTeams.Where(x => x.Auditor != null))
            {
                var user = await _userManager.FindByIdAsync(auditorTeam.Auditor!.UserId);

                auditorTeam.Auditor.Name = string.Join(" ",
                    new[]
                    {
                        user?.Prefix,
                        user?.FirstName,
                        user?.MiddleName,
                        user?.LastName,
                        user?.Suffix
                    }
                    .Where(x => !string.IsNullOrWhiteSpace(x)));
            }

            // Group by Team
            var grouped = auditorTeams.GroupBy(at => at.TeamId).Select(group => new AuditorTeamsDto
            {
                Id = group.Key,
                TeamId = group.Key,
                Auditors = group
                    .Where(at => at.Auditor != null)
                    .Select(at => new AuditorDto
                    {
                        Id = at.Auditor!.Id,
                        Name = at.Auditor.Name,
                        UserId = at.Auditor.UserId,
                        IsActive = at.Auditor.IsActive,
                        IsTeamLeader = at.IsTeamLeader
                    })
                    .ToList(),
                IsActive = group.First().IsActive
            })
            .ToList();

            var totalCount = grouped.Count;

            var pagedItems = grouped
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return new AuditorTeamsPageDto
            {
                Items = pagedItems,
                Page = page,
                PageSize = pageSize,
                TotalCount = totalCount               
            };
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
        public async Task<AuditorTeamsDto?> GetByTeamIdAsync(long teamId, CancellationToken cancellationToken)
        {
            var auditorTeams = await _repository.GetByTeamIdAsync(teamId, cancellationToken).ConfigureAwait(false);

            if (auditorTeams == null || !auditorTeams.Any())
                return null;

            var auditors = new List<AuditorDto>();

            foreach (var auditorTeam in auditorTeams.Where(x => x.Auditor != null))
            {
                var user = await _userManager.FindByIdAsync(auditorTeam.Auditor!.UserId);

                var fullName = string.Join(" ",
                    new[]
                    {
                        user?.Prefix,
                        user?.FirstName,
                        user?.MiddleName,
                        user?.LastName,
                        user?.Suffix
                    }
                    .Where(x => !string.IsNullOrWhiteSpace(x)));

                auditors.Add(new AuditorDto
                {
                    Id = auditorTeam.Auditor.Id,
                    Name = fullName,
                    IsTeamLeader = auditorTeam.IsTeamLeader,
                    IsActive = auditorTeam.Auditor.IsActive,
                    UserId = auditorTeam.Auditor.UserId
                });
            }

            return new AuditorTeamsDto
            {
                Id = auditorTeams.First().Id,
                TeamId = auditorTeams.First().TeamId,
                IsActive = auditorTeams.First().IsActive,
                Auditors = auditors
            };
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
