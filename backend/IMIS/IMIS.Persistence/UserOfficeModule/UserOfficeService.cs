using Base.Pagination;
using Base.Primitives;
using IMIS.Application.UserOfficeModule;
using IMIS.Domain;

namespace IMIS.Persistence.UserOfficeModule
{
    public class UserOfficeService : IUserOfficeService
    {
        private readonly IUserOfficeRepository _repository;     

        public UserOfficeService(IUserOfficeRepository repository)          
        {
            _repository = repository;            
        }
      
        private UserOfficeDto ConvertToDTO(UserOffices userOffices)
        {
            if (userOffices == null) return null;

            return new UserOfficeDto
            {
                Id = userOffices.Id,
                UserId = userOffices.UserId,
                OfficeId = userOffices.OfficeId, 
                IsActive = userOffices.IsActive
            };
        }
        public async Task<DtoPageList<UserOfficeDto, UserOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var userOffice = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (userOffice.TotalCount == 0)
                return null;
            return DtoPageList<UserOfficeDto, UserOffices, int>.Create(userOffice.Items, page, pageSize, userOffice.TotalCount);
        }

        public async Task<UserOfficeDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var userOfficeDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return userOfficeDto != null ? ConvertToDTO(userOfficeDto) : null;
        }
        public async Task<List<UserOfficeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var userOfficeDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return userOfficeDto?.Select(o => ConvertToDTO(o)).ToList();
        }

        public async Task<UserOfficeDto> SaveOrUpdateAsync(UserOfficeDto userOfficeDto, CancellationToken cancellationToken)
        {
            if (userOfficeDto == null) throw new ArgumentNullException(nameof(userOfficeDto));

            var userOfficeEntity = userOfficeDto.ToEntity();           
            // Handle Save or Update
            var createdUserOffice = await _repository.SaveOrUpdateAsync(userOfficeEntity, cancellationToken);

            return new UserOfficeDto
            {
                Id = createdUserOffice.Id,
                UserId = createdUserOffice.UserId,
                OfficeId = createdUserOffice.OfficeId,
                IsActive = createdUserOffice.IsActive,               
            };
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not UserOfficeDto userOfficeDto)
                throw new ArgumentException("Invalid User Office Dto type", nameof(dto));

            var userOfficeEntity = userOfficeDto.ToEntity();          
            await _repository.SaveOrUpdateAsync(userOfficeEntity, cancellationToken);
        }
    }
}
