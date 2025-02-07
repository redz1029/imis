using Base.Primitives;
using IMIS.Application.PgsKraModule;

namespace IMIS.Persistence.KraModule
{
    public class KraService(IKraRepository repository) : IKraService 
    {

        private readonly IKraRepository _repository = repository;

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
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not KraDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }   
}
