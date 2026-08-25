using Base.Primitives;
using IMIS.Application.PerformanceValidationToolDeliverableFindingsModule;

namespace IMIS.Persistence.PerformanceValidationToolDeliverableFindingsModule
{
    public class PerformanceValidationToolDeliverableFindingsService : IPerformanceValidationToolDeliverableFindingsService
    {
      
        private readonly IPerformanceValidationToolDeliverableFindingsRepository _repository;
        public PerformanceValidationToolDeliverableFindingsService(IPerformanceValidationToolDeliverableFindingsRepository repository)
        {
            _repository = repository;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as PerformanceValidationToolDeliverableFindingsDto;
            var performanceValidationToolDeliverableFindingsDto = ODto!.ToEntity();

            if (performanceValidationToolDeliverableFindingsDto.Id == 0)
                _repository.Add(performanceValidationToolDeliverableFindingsDto);
            else
                await _repository.UpdateAsync(performanceValidationToolDeliverableFindingsDto, performanceValidationToolDeliverableFindingsDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(performanceValidationToolDeliverableFindingsDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
