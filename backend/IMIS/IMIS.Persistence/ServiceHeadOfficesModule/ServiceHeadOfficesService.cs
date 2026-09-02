using Base.Pagination;
using Base.Primitives;
using IMIS.Application.ServiceHeadOfficesModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.ServiceHeadOfficesModule
{
    public class ServiceHeadOfficesService : IServiceHeadOfficesService
    {

        private readonly IServiceHeadOfficesRepository _repository;
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;

        public ServiceHeadOfficesService(IServiceHeadOfficesRepository repository, UserManager<User> userManager, RoleManager<IdentityRole> roleManager)
        {
            _repository = repository;
            _userManager = userManager;
            _roleManager = roleManager;
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var serviceHeadOfficesDto = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (serviceHeadOfficesDto == null)
                return false;

            serviceHeadOfficesDto.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<DtoPageList<ServiceHeadOfficesDto, ServiceHeadOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var serviceHeadOfficesDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (serviceHeadOfficesDto.TotalCount == 0)
                return null!;
            return DtoPageList<ServiceHeadOfficesDto, ServiceHeadOffices, int>.Create(serviceHeadOfficesDto.Items, page, pageSize, serviceHeadOfficesDto.TotalCount);
        }
        public async Task<ServiceHeadOfficesDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var serviceHeadOfficesDto = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return serviceHeadOfficesDto != null ? new ServiceHeadOfficesDto(serviceHeadOfficesDto) : null;
        }
        public async Task<List<ServiceHeadOfficesDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var serviceHeadOfficesDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (serviceHeadOfficesDto == null)
                return null;

            return serviceHeadOfficesDto.Select(d => new ServiceHeadOfficesDto(d)).ToList();
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {

            var ODto = dto as ServiceHeadOfficesDto;
            if (ODto == null) throw new ArgumentException("Invalid DTO type.");

            var serviceHeadOfficesDto = ODto!.ToEntity();

            if (serviceHeadOfficesDto.Id == 0)
                _repository.Add(serviceHeadOfficesDto);
            else
                await _repository.UpdateAsync(serviceHeadOfficesDto, serviceHeadOfficesDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(serviceHeadOfficesDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
