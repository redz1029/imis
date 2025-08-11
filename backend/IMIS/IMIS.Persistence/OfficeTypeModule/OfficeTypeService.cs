

using Base.Primitives;
using IMIS.Application.OfficeTypeModule;
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
