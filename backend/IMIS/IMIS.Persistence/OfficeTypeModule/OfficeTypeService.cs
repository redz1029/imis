

using Base.Primitives;
using IMIS.Application.AuditorModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.OfficeTypeModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Persistence.OfficeTypeModule
{
    public class OfficeTypeService : IOfficeTypeService
    {
        private readonly IOfficeTypeRepository _repository;

        public OfficeTypeService(IOfficeTypeRepository repository)
        {
            _repository = repository;
        }
        private static OfficeTypeDto ConvOfficeToDTO(OfficeType officetype)
        {
            return new OfficeTypeDto()
            {
                Id = officetype.Id,
                Name = officetype.Name,
                IsActive = officetype.IsActive,              
            };
        }
        public async Task<List<OfficeTypeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var offices = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return offices?.Select(o => ConvOfficeToDTO(o)).ToList();
        }
        public async Task<OfficeTypeDto> SaveOrUpdateAsync(OfficeTypeDto officeTypeDto, CancellationToken cancellationToken)
        {
            if (officeTypeDto == null) throw new ArgumentNullException(nameof(officeTypeDto));

            OfficeType officeTypeDtoEntity;
            // Check if the period exists, and update it, otherwise create a new one
            if (officeTypeDto.Id > 0)
            {
                // Update logic
                var existingOfficeType = await _repository.GetByIdAsync(officeTypeDto.Id, cancellationToken).ConfigureAwait(false);
                if (existingOfficeType != null)
                {
                    existingOfficeType.Name = officeTypeDto.Name;
                    existingOfficeType.IsActive = officeTypeDto.IsActive;                   
                    // Update the existing entity
                    officeTypeDtoEntity = existingOfficeType;
                }
                else
                {
                    // If the period doesn't exist, create a new one
                    officeTypeDtoEntity = officeTypeDto.ToEntity();
                }
            }
            else
            {
                // Create a new record if ID is 0 or not specified
                officeTypeDtoEntity = officeTypeDto.ToEntity();
            }
            var savedofficeTypeDto = await _repository.SaveOrUpdateAsync(officeTypeDtoEntity, cancellationToken).ConfigureAwait(false);
            return new OfficeTypeDto
            {
                Id = officeTypeDto.Id,
                Name = officeTypeDto.Name,
                IsActive = officeTypeDto.IsActive,               
            };
        }
     
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as OfficeTypeDto;
            var officetype = ODto!.ToEntity();

            if (officetype.Id == 0)
                _repository.Add(officetype);
            else
                await _repository.UpdateAsync(officetype, officetype.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(officetype, cancellationToken).ConfigureAwait(false);
        }
    }
}
