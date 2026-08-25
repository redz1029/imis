using Base.Auths;
using Base.Auths.Roles;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.EvaluatorOfficesModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.EvaluatorOfficesModule
{
    public class EvaluatorOfficesService : IEvaluatorOfficesService
    {
        private readonly IEvaluatorOfficesRepository _repository;
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;

        public EvaluatorOfficesService(IEvaluatorOfficesRepository repository, UserManager<User> userManager, RoleManager<IdentityRole> roleManager)
        {
            _repository = repository;
            _userManager = userManager;
            _roleManager = roleManager;
        }
       
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var evaluatorOfficesDto = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (evaluatorOfficesDto == null)
                return false;

            evaluatorOfficesDto.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<DtoPageList<EvaluatorOfficesDto, EvaluatorOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var evaluatorOfficesDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (evaluatorOfficesDto.TotalCount == 0)
                return null!;
            return DtoPageList<EvaluatorOfficesDto, EvaluatorOffices, int>.Create(evaluatorOfficesDto.Items, page, pageSize, evaluatorOfficesDto.TotalCount);
        }
        public async Task<EvaluatorOfficesDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var evaluatorOfficesDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return evaluatorOfficesDto != null ? new EvaluatorOfficesDto(evaluatorOfficesDto) : null;
        }
        public async Task<List<EvaluatorOfficesDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var evaluatorOfficesDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (evaluatorOfficesDto == null)
                return null;

            return evaluatorOfficesDto.Select(d => new EvaluatorOfficesDto(d)).ToList();
        }
        private async Task<User?> GetCurrentUserAsync()
        {
            var currentUserService = CurrentUserHelper<User>.GetCurrentUserService();
            return currentUserService != null ? await currentUserService.GetCurrentUserAsync() : null;
        }
       
        public async Task<List<EvaluatorOfficesDto>?> GetAllServicesAsync(CancellationToken cancellationToken)
        {
            var currentUser = await GetCurrentUserAsync();

            if (currentUser == null)
                return null;

            IEnumerable<EvaluatorOffices> evaluatorOffices;

            var userRoles = await _userManager.GetRolesAsync(currentUser);

            var isPrivilegedUser =
                userRoles.Contains(new AdministratorRole().Name, StringComparer.OrdinalIgnoreCase) ||
                userRoles.Contains(new PgsServiceHead().Name, StringComparer.OrdinalIgnoreCase) ||
                userRoles.Contains(new PgsAuditorHead().Name, StringComparer.OrdinalIgnoreCase) ||
                userRoles.Contains(new PgsManagerRole().Name, StringComparer.OrdinalIgnoreCase) ||
                userRoles.Contains(new PgsHead().Name, StringComparer.OrdinalIgnoreCase) ||
                userRoles.Contains(new MCC().Name, StringComparer.OrdinalIgnoreCase) ||
                userRoles.Contains(new OSM().Name, StringComparer.OrdinalIgnoreCase) ||
                userRoles.Contains(new MSGC().Name, StringComparer.OrdinalIgnoreCase) ||
                userRoles.Contains(new TWG().Name, StringComparer.OrdinalIgnoreCase);

            if (isPrivilegedUser)
            {
                evaluatorOffices = await _repository.GetAllServicesAsync(cancellationToken).ConfigureAwait(false);
            }
            else
            {
                evaluatorOffices = await _repository.GetServicesByUserIdAsync(currentUser.Id, cancellationToken).ConfigureAwait(false);

                if (evaluatorOffices == null || !evaluatorOffices.Any())
                    return [];
            }

            return evaluatorOffices
                .Select(e => new EvaluatorOfficesDto(e))
                .ToList();
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {

            var ODto = dto as EvaluatorOfficesDto;
            if (ODto == null) throw new ArgumentException("Invalid DTO type.");
           
            var evaluatorOfficesDto = ODto!.ToEntity();

            if (evaluatorOfficesDto.Id == 0)
                _repository.Add(evaluatorOfficesDto);
            else
                await _repository.UpdateAsync(evaluatorOfficesDto, evaluatorOfficesDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(evaluatorOfficesDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
