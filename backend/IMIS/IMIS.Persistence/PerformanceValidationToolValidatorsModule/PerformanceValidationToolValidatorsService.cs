using Base.Primitives;
using IMIS.Application.PerformanceValidationToolValidatorsModule;

namespace IMIS.Persistence.PerformanceValidationToolValidatorsModule
{
    internal class PerformanceValidationToolValidatorsService : IPerformanceValidationToolValidatorsService
    {
       
        private readonly IPerformanceValidationToolValidatorsRepository _repository;
        public PerformanceValidationToolValidatorsService(IPerformanceValidationToolValidatorsRepository repository)
        {
            _repository = repository;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as PerformanceValidationToolValidatorsDto;
            var performanceValidationToolValidatorsDto = ODto!.ToEntity();

            if (performanceValidationToolValidatorsDto.Id == 0)
                _repository.Add(performanceValidationToolValidatorsDto);
            else
                await _repository.UpdateAsync(performanceValidationToolValidatorsDto, performanceValidationToolValidatorsDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(performanceValidationToolValidatorsDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
