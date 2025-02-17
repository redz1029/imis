using Base.Primitives;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Persistence.KraModule
{
    public class KraService : IKraService
    {
        private readonly IKraRepository _repository;
        // Constructor for injecting the repository
        public KraService(IKraRepository repository)
        {
            _repository = repository;  // Correct assignment
        }
        // Convert Kra entity to KraDto
        private KraDto ConvOfficeToDTO(Kra kra)
        {
            if (kra == null) return null;

            return new KraDto
            {
                Id = kra.Id,
                Name = kra.Name,
                Remarks = kra.Remarks
            };
        }
        // Fixed async method
        public async Task<KraDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var kradto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return kradto != null ? ConvOfficeToDTO(kradto) : null;
        }
        public async Task<List<KraDto>?> GetAllAsync(CancellationToken cancellationToken)
        {          
            var offices = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return offices?.Select(o => ConvOfficeToDTO(o)).ToList();
        }      
        // Fixed async method
        public async Task<KraDto> SaveOrUpdateAsync(KraDto KraDto, CancellationToken cancellationToken)
        {
            if (KraDto == null) throw new ArgumentNullException(nameof(KraDto));
            var pgsEntity = KraDto.ToEntity();
            var createdKra = await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
            return new KraDto
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
            if (dto is not KraDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));
            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}

