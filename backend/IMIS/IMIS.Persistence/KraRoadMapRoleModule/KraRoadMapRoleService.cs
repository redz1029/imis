using Base.Auths;
using Base.Auths.Roles;
using Base.Primitives;
using IMIS.Application.KraRoadMapRoleAssignmentModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraRoadMapRoleModule
{
    public class KraRoadMapRoleService : IKraRoadMapRoleService
    {
        private readonly IKraRoadMapRoleRepository _repository;
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;

        public KraRoadMapRoleService(IKraRoadMapRoleRepository repository, UserManager<User> userManager, RoleManager<IdentityRole> roleManager)
        {
            _repository = repository;
            _userManager = userManager;
            _roleManager = roleManager;
        }
        
        private async Task<User?> GetCurrentUserAsync()
        {
            var currentUserService = CurrentUserHelper<User>.GetCurrentUserService();
            return await currentUserService!.GetCurrentUserAsync();
        }
      
        public async Task<List<KraRoadMapRoleDto>> GetAllRoadmapForUserAsync(CancellationToken cancellationToken)
        {
          
            var currentUser = await GetCurrentUserAsync();
            if (currentUser == null)
                return new List<KraRoadMapRoleDto>();

            var userRoleNames = await _userManager.GetRolesAsync(currentUser);

            List<KraRoadMapRole> roadmaps = new();

            if (userRoleNames.Any(r => r.Equals(new AdministratorRole().Name, StringComparison.OrdinalIgnoreCase)))
            {
                var allRoadmaps = await _repository.GetAll(cancellationToken);
                roadmaps = allRoadmaps?.ToList() ?? new List<KraRoadMapRole>();
            }
            else
            {
              
                var rolesWithIds = await _roleManager.Roles
                    .Where(r => userRoleNames.Contains(r.Name!))
                    .ToListAsync(cancellationToken);

                foreach (var role in rolesWithIds)
                {
                    var roleRoadmaps = await _repository.GetByRoleIdAsync(role.Id, cancellationToken);
                    if (roleRoadmaps != null && roleRoadmaps.Any())
                        roadmaps.AddRange(roleRoadmaps);
                }
            }
           
            return roadmaps.Select(r => new KraRoadMapRoleDto(r)).ToList();
        }
       
        public async Task<List<KraRoadMapRoleDto>?> GetAll(CancellationToken cancellationToken)
        {
            var list = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (list == null) return null;          
            return list.Select(r => new KraRoadMapRoleDto(r)).ToList();
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var auditorDto = dto as KraRoadMapRoleDto;
            var auditor = auditorDto!.ToEntity();
            if (auditor.Id == 0)
                _repository.Add(auditor);
            else
            {
                await _repository.UpdateAsync(auditor, auditor.Id, cancellationToken).ConfigureAwait(false);
            }
            await _repository.SaveOrUpdateAsync(auditor, cancellationToken).ConfigureAwait(false);
        }
    }
}
