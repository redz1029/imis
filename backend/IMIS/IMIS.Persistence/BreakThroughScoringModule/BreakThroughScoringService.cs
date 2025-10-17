using Base.Primitives;
using IMIS.Application.BreakThroughScoringModule;

namespace IMIS.Persistence.BreakThroughScoringModule
{
    public class BreakThroughScoringService : IBreakThroughScoringService
    {
        private readonly IBreakThroughScoringRepository _repository;
        public BreakThroughScoringService(IBreakThroughScoringRepository repository)
        {
            _repository = repository;
        }
        public async Task<BreakThroughScoringDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken);
            return entity is null ? null : new BreakThroughScoringDto(entity);
        }
        public async Task<BreakThroughScoringDto?> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken)
        {
            var breakThroughScoring = await _repository
                .GetByDeliverableIdAsync(deliverableId, cancellationToken)
                .ConfigureAwait(false);
              
            return breakThroughScoring is null
                ? null
                : new BreakThroughScoringDto(breakThroughScoring);
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as BreakThroughScoringDto;
            var breakThroughScoringDto = ODto!.ToEntity();

            if (breakThroughScoringDto.Id == 0)
                _repository.Add(breakThroughScoringDto);
            else
                await _repository.UpdateAsync(breakThroughScoringDto, breakThroughScoringDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(breakThroughScoringDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
