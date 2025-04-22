using Base.Pagination;
using Base.Primitives;
using IMIS.Application.UserOfficeModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.UserOfficeModule
{
    public class UserOfficeService : IUserOfficeService
    {
        private readonly IUserOfficeRepository _repository;
        private readonly UserManager<User> _userManager;

        public UserOfficeService(IUserOfficeRepository repository, UserManager<User> userManager)          
        {
            _repository = repository;
            _userManager = userManager;
        }

        private async Task<UserOfficeDto> ConvertToDTO(UserOffices userOffices, List<User> users, CancellationToken cancellationToken)
        {
            if (userOffices == null) return null;

            // Find the corresponding user based on UserId
            var user = users.FirstOrDefault(u => u.Id == userOffices.UserId);
         
            if (user == null)
            {               
                return new UserOfficeDto
                {
                    Id = userOffices.Id,
                    UserId = userOffices.UserId,
                    OfficeId = userOffices.OfficeId,
                    IsActive = userOffices.IsActive
                };
            }           
            return new UserOfficeDto
            {
                Id = userOffices.Id,
                UserId = userOffices.UserId,
                OfficeId = userOffices.OfficeId,
                IsActive = userOffices.IsActive,
                FirstName = user.FirstName,
                MiddleName = user.MiddleName,
                LastName = user.LastName,
                Prefix = user.Prefix,
                Suffix = user.Suffix,
                Position = user.Position
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
            // Fetch the user office from the repository by ID
            var userOffice = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);

            if (userOffice == null)
            {
                return null; // Return null if no UserOffice is found
            }
          
            var user = await _userManager.FindByIdAsync(userOffice.UserId);

            if (user == null)
            {               
                return new UserOfficeDto
                {
                    Id = userOffice.Id,
                    UserId = userOffice.UserId,
                    OfficeId = userOffice.OfficeId,
                    IsActive = userOffice.IsActive
                };
            }            
            return new UserOfficeDto
            {
                Id = userOffice.Id,
                UserId = userOffice.UserId,
                OfficeId = userOffice.OfficeId,
                IsActive = userOffice.IsActive,
                FirstName = user.FirstName,
                MiddleName = user.MiddleName,
                LastName = user.LastName,
                Prefix = user.Prefix,
                Suffix = user.Suffix,
                Position = user.Position
            };
        }
        public async Task<List<UserOfficeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {         
            var userOffices = await _repository.GetAll(cancellationToken).ConfigureAwait(false);

            if (userOffices == null || !userOffices.Any())
            {
                return null;
            }

            // Fetch all users at once (instead of per UserOffice)
            var userIds = userOffices.Select(o => o.UserId).Distinct().ToList();
            var users = await _userManager.Users.Where(u => userIds.Contains(u.Id)).ToListAsync(cancellationToken);
            
            var userOfficeDtos = await Task.WhenAll(userOffices.Select(o => ConvertToDTO(o, users, cancellationToken)));
       
            return userOfficeDtos.ToList();
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
