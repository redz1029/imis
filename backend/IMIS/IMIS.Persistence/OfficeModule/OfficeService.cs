using Base.Primitives;
using IMIS.Application.OfficeModule;

namespace IMIS.Persistence.OfficeModule
{
    public class OfficeService(IOfficeRepository repository) : IOfficeService
    {
        private readonly IOfficeRepository _repository = repository;

        public async Task<List<OfficeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var offices = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return offices?.Select(o => 
                new OfficeDto() 
                    { 
                        Id = o.Id, 
                        Name = o.Name, 
                        IsActive = o.IsActive 
                }).ToList();
        }

        public async Task<OfficeDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var office = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return office != null 
                ? new OfficeDto() 
                { 
                    Id = office.Id, 
                    Name = office.Name, 
                    IsActive = office.IsActive
                } 
                : null;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as OfficeDto;
            var office = ODto!.ToEntity();
            _repository.Add(office);
            await _repository.SaveOrUpdateAsync(office, cancellationToken).ConfigureAwait(false);
        }
    }
}
