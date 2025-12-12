using Base.Primitives;
using IMIS.Application.KraRoadMapKpiModule;

namespace IMIS.Persistence.KraRoadMapKpiModule
{
    public class KraRoadMapKpiService : IKraRoadMapKpiService
    {
        private readonly IKraRoadMapKpiRepository _repository;
        public KraRoadMapKpiService(IKraRoadMapKpiRepository repository)
        {
            _repository = repository;
        }
      
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as KraRoadMapKpiDto;
            var kraRoadMapKpiDto = ODto!.ToEntity();

            if (kraRoadMapKpiDto.Id == 0)
                _repository.Add(kraRoadMapKpiDto);
            else
                await _repository.UpdateAsync(kraRoadMapKpiDto, kraRoadMapKpiDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(kraRoadMapKpiDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
