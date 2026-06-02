using Base.Primitives;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Application.KraRoadMapModule;

namespace IMIS.Persistence.KraRoadMapKpiModule
{
    public class KraRoadMapKpiService : IKraRoadMapKpiService
    {
        private readonly IKraRoadMapKpiRepository _repository;
        public KraRoadMapKpiService(IKraRoadMapKpiRepository repository)
        {
            _repository = repository;
        }

        public async Task<List<KraRoadMapKpiDeliverableFilterDto>> GetKpiByRoadMapIdAsync(long kraRoadMapId, int year, CancellationToken cancellationToken)
        {
            var kpis = await _repository.GetKpisByRoadMapIdAsync(kraRoadMapId, year, cancellationToken);

            if (!kpis.Any())
                return new List<KraRoadMapKpiDeliverableFilterDto>();

            var roadmapPeriods = await _repository.GetRoadMapPeriodsForKpisAsync(kpis, cancellationToken);
            var grouped = kpis
                .GroupBy(k =>
                    roadmapPeriods.First(r =>
                        r.KraRoadMapId == k.KraRoadMapId))
                .Select(g => new KraRoadMapKpiDeliverableFilterDto
                {
                    StartDate = DateOnly.FromDateTime(g.Key.StartYear),
                    EndDate = DateOnly.FromDateTime(g.Key.EndYear),

                    KpiDeliverable = g
                        .Select(k => new KraRoadMapKpiDto(k))
                        .ToList()
                })
                .OrderBy(x => x.StartDate)
                .ToList();

            return grouped;
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
