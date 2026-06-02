using Base.Primitives;
using IMIS.Application.KraRoadmapAccomplishmentModule;
using IMIS.Application.PgsDeliverableAccomplishmentModule;

namespace IMIS.Persistence.KraRoadMapAccomplishmentModule
{
    public class KraRoadMapAccomplishmentService : IKraRoadmapAccomplishmentService
    {
        private readonly IKraRoadmapAccomplishmentRepository _repository;

        public KraRoadMapAccomplishmentService(IKraRoadmapAccomplishmentRepository repository)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));           
        }
        public async Task<KraRoadmapAccomplishmentDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken);
            return entity == null ? null : new KraRoadmapAccomplishmentDto(entity);
        }
        public async Task<List<KraRoadmapAccomplishmentDto>> GetByDeliverableIdAsync(long kradeliverableId, CancellationToken cancellationToken)
        {
            var accomplishments = await _repository.GetByDeliverableIdAsync(kradeliverableId, cancellationToken).ConfigureAwait(false);

            return accomplishments.Select(a => new KraRoadmapAccomplishmentDto(a)).ToList();
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is KraRoadmapAccomplishmentDto accomplishmentDto)
            {
                var accomplishment = accomplishmentDto.ToEntity();

                if (accomplishment.Id == 0)
                    _repository.Add(accomplishment);
                else
                    await _repository.UpdateAsync(accomplishment, accomplishment.Id, cancellationToken)
                        .ConfigureAwait(false);

                await _repository.SaveOrUpdateAsync(accomplishment, cancellationToken)
                    .ConfigureAwait(false);
               
            }
        }
    }
}
