using Base.Primitives;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Application.KraRoadMapModule;

namespace IMIS.Persistence.KraRoadMapDeliverableModule
{
    public class KraRoadMapDeliverableService : IKraRoadMapDeliverableService
    {
        private readonly IKraRoadMapDeliverableRepository _repository;
        public KraRoadMapDeliverableService(IKraRoadMapDeliverableRepository repository)
        {
            _repository = repository;
        }
     
        public async Task<List<FilterKraPeriodKraDeliverableDto>> GetByRoadMapIdAsync(long kraRoadMapId, int year,
        CancellationToken cancellationToken)
        {
            var deliverables = await _repository.GetByRoadMapIdAsync(kraRoadMapId, year, cancellationToken);

            if (!deliverables.Any())
                return new List<FilterKraPeriodKraDeliverableDto>();

            var roadmapPeriods = await _repository.GetRoadMapPeriodsAsync(deliverables, cancellationToken);

            var grouped = deliverables
                .GroupBy(d =>
                    roadmapPeriods.First(r =>
                        r.KraRoadMapId == d.KraRoadMapId))
                .Select(g => new FilterKraPeriodKraDeliverableDto
                {
                    StartDate = DateOnly.FromDateTime(g.Key.StartYear),
                    EndDate = DateOnly.FromDateTime(g.Key.EndYear),

                    Deliverables = g
                        .Select(d => new KraRoadMapDeliverableDto(d))
                        .ToList()
                })
                .OrderBy(x => x.StartDate)
                .ToList();

            return grouped;
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
