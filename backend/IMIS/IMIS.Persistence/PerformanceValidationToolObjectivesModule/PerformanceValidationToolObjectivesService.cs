using Base.Primitives;
using IMIS.Application.PerformanceValidationToolObjectivesModule;

namespace IMIS.Persistence.PerformanceValidationToolObjectivesModule
{
    public class PerformanceValidationToolObjectivesService : IPerformanceValidationToolObjectivesService
    {
        private readonly IPerformanceValidationToolObjectivesRepository _repository;
        public PerformanceValidationToolObjectivesService(
          IPerformanceValidationToolObjectivesRepository repository)
        {
            _repository = repository;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
        where TEntity : Entity<TId>
        {
            var ODto = dto as PerformanceValidationToolObjectivesDto;
            var performanceValidationToolObjectivesDto = ODto!.ToEntity();

            if (performanceValidationToolObjectivesDto.Id == 0)
                _repository.Add(performanceValidationToolObjectivesDto);
            else
                await _repository.UpdateAsync(performanceValidationToolObjectivesDto, performanceValidationToolObjectivesDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(performanceValidationToolObjectivesDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
