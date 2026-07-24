using Base.Primitives;
using IMIS.Application.KraRoadmapHistoryModule;

namespace IMIS.Persistence.KraRoadmapHistoryModule
{
    public class KraRoadmapHistoryService : IKraRoadmapHistoryService
    {
        private readonly IKraRoadmapHistoryRepository _repository;
        public KraRoadmapHistoryService(IKraRoadmapHistoryRepository repository)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
         
        }
        public async Task<List<KraRoadmapHistoryDto>?> GetAll(long? performanceGovernanceSystemId, CancellationToken cancellationToken)
        {
            var data = await _repository.GetAll(performanceGovernanceSystemId, cancellationToken).ConfigureAwait(false);

            return data?.Select(a => new KraRoadmapHistoryDto(a)).ToList();
        }
        public Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            throw new NotImplementedException();
        }
    }
}
