using Base.Primitives;
using IMIS.Application.KraRoadmapKpiAccomplishmentModule;

namespace IMIS.Persistence.KraRoadMapKpiAccomplishmentModule
{
    public class KraRoadMapKpiAccomplishmentService : IKraRoadmapKpiAccomplishmentService
    {
        private readonly IKraRoadmapKpiAccomplishmentRepository _repository;

        public KraRoadMapKpiAccomplishmentService(IKraRoadmapKpiAccomplishmentRepository repository)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
        }
        public async Task<KraRoadmapKpiAccomplishmentDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken);
            return entity == null ? null : new KraRoadmapKpiAccomplishmentDto(entity);
        }
        public async Task<List<KraRoadmapKpiAccomplishmentDto>> GetByKpiIdAsync(long kraKpiId, CancellationToken cancellationToken)
        {
            var accomplishments = await _repository.GetByKpiIdAsync(kraKpiId, cancellationToken).ConfigureAwait(false);

            return accomplishments.Select(a => new KraRoadmapKpiAccomplishmentDto(a)).ToList();
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is KraRoadmapKpiAccomplishmentDto accomplishmentDto)
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
