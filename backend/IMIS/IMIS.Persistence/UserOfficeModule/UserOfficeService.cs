using Base.Primitives;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
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
        private UserOfficeDto ConvertToDTO(UserOffices entity)
        {
            if (entity == null) return null;

            return new UserOfficeDto
            {
                Id = entity.Id,
                UserId = entity.UserId,
                OfficeId = entity.OfficeId, 
                IsActive = entity.IsActive
            };
        }
        public async Task<UserOfficeDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var kradto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return kradto != null ? ConvertToDTO(kradto) : null;
        }
        public async Task<List<UserOfficeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var PgsReadiness = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return PgsReadiness?.Select(o => ConvertToDTO(o)).ToList();
        }

        public async Task<UserOfficeDto> SaveOrUpdateAsync(UserOfficeDto user, CancellationToken cancellationToken)
        {
            if (user == null) throw new ArgumentNullException(nameof(user));

            var pgsEntity = user.ToEntity();           
            // Handle Save or Update
            var createdPgs = await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken);

            return new UserOfficeDto
            {
                Id = createdPgs.Id,
                UserId = createdPgs.UserId,
                OfficeId = createdPgs.OfficeId,
                IsActive = createdPgs.IsActive,               
            };
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not UserOfficeDto userOfficeDto)
                throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = userOfficeDto.ToEntity();          
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken);
        }
    }
}
