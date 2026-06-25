using Base.Primitives;
using IMIS.Application.PerformanceValidationToolConclusionModule;

namespace IMIS.Persistence.PerformanceValidationToolConclusionModule
{
    public class PerformanceValidationToolConclusionService : IPerformanceValidationToolConclusionService
    {
        private readonly IPerformanceValidationToolConclusionRepository _repository;
        public PerformanceValidationToolConclusionService(IPerformanceValidationToolConclusionRepository repository)
        {
            _repository = repository;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as PerformanceValidationToolConclusionDto;
            var performanceValidationToolConclusionDto = ODto!.ToEntity();

            if (performanceValidationToolConclusionDto.Id == 0)
                _repository.Add(performanceValidationToolConclusionDto);
            else
                await _repository.UpdateAsync(performanceValidationToolConclusionDto, performanceValidationToolConclusionDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(performanceValidationToolConclusionDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
