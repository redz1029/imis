using Base.Abstractions;
using Base.Primitives;
using IMIS.Application.KraRoadmapCoreSupportProcessModule;
using IMIS.Domain;

namespace IMIS.Persistence.KraRoadmapCoreSupportProcessModule
{
    public class KraRoadmapCoreSupportProcessService : IKraRoadmapCoreSupportProcessService
    {

        private readonly IKraRoadmapCoreSupportProcessRepository _repository;
        public KraRoadmapCoreSupportProcessService(IKraRoadmapCoreSupportProcessRepository repository)
        {
            _repository = repository;       
        }


        public async Task<List<KraProcessGroupedDto>?> ReportGetByIdAsync(int kraRoadMapPeriodId, CancellationToken cancellationToken)
        {
            var grouped = await _repository.GetGroupedAsync(kraRoadMapPeriodId, cancellationToken);

            if (!grouped.Any())
                return grouped;

            var processIds = grouped.Select(x => x.ProcessId).ToList();
            var processNames = await _repository.GetProcessNamesAsync(processIds, cancellationToken);

            foreach (var g in grouped)
            {
                g.ProcessName = processNames.GetValueOrDefault(g.ProcessId);
            }

            return grouped;
        }

     
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as KraRoadmapCoreSupportProcessDto;
            var kraRoadmapCoreSupportProcessDto = ODto!.ToEntity();

            if (kraRoadmapCoreSupportProcessDto.Id == 0)
                _repository.Add(kraRoadmapCoreSupportProcessDto);
            else
                await _repository.UpdateAsync(kraRoadmapCoreSupportProcessDto, kraRoadmapCoreSupportProcessDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(kraRoadmapCoreSupportProcessDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
