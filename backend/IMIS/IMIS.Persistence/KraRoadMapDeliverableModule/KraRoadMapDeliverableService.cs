using Base.Primitives;
using IMIS.Application.KraRoadMapDeliverableModule;

namespace IMIS.Persistence.KraRoadMapDeliverableModule
{
    public class KraRoadMapDeliverableService : IKraRoadMapDeliverableService
    {
        private readonly IKraRoadMapDeliverableRepository _repository;
        public KraRoadMapDeliverableService(IKraRoadMapDeliverableRepository repository)
        {
            _repository = repository;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as KraRoadMapDeliverableDto;
            var kraRoadMapDeliverableDto = ODto!.ToEntity();

            if (kraRoadMapDeliverableDto.Id == 0)
                _repository.Add(kraRoadMapDeliverableDto);
            else
                await _repository.UpdateAsync(kraRoadMapDeliverableDto, kraRoadMapDeliverableDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(kraRoadMapDeliverableDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
