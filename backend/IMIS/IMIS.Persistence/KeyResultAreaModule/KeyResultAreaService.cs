using Base.Primitives;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Persistence.KraModule
{
    public class KeyResultAreaService : IKeyResultAreaService
    {
        private readonly IKeyResultAreaRepository _repository;
        // Constructor for injecting the repository
        public KeyResultAreaService(IKeyResultAreaRepository repository)
        {
            _repository = repository;  // Correct assignment
        }
        // Convert Kra entity to KraDto
        private KeyResultAreaDto ConvOfficeToDTO(KeyResultArea kra)
        {
            if (kra == null) return null;

            return new KeyResultAreaDto
            {
                Id = kra.Id,
                Name = kra.Name,
                Remarks = kra.Remarks
            };
        }
        // Fixed async method
        public async Task<KeyResultAreaDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var kradto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return kradto != null ? ConvOfficeToDTO(kradto) : null;
        }
        public async Task<List<KeyResultAreaDto>?> GetAllAsync(CancellationToken cancellationToken)
        {          
            var offices = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return offices?.Select(o => ConvOfficeToDTO(o)).ToList();
        }      
        // Fixed async method
        public async Task<KeyResultAreaDto> SaveOrUpdateAsync(KeyResultAreaDto KraDto, CancellationToken cancellationToken)
        {
            if (KraDto == null) throw new ArgumentNullException(nameof(KraDto));
            var pgsEntity = KraDto.ToEntity();
            var createdKra = await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
            return new KeyResultAreaDto
            {
                Id = createdKra.Id,
                Name = createdKra.Name,
                Remarks = createdKra.Remarks
            };
        }
        // Fixed async method
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not KeyResultAreaDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));
            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}

