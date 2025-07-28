using Base.Primitives;
using IMIS.Application.PgsDeliverableHistoryModule;

namespace IMIS.Persistence.PgsDeliverableHistoryModule
{
    public class PgsDeliverableHistoryService : IPgsDeliverableHistoryService
    {
        private readonly IPgsDeliverableHistoryRepository _repository;
        public PgsDeliverableHistoryService(IPgsDeliverableHistoryRepository repository)
        {
            _repository = repository;           
        }
        public async Task<PgsDeliverableHistoryDto> SaveOrUpdateAsync(PgsDeliverableHistoryDto pgsDeliverableHistoryDto, CancellationToken cancellationToken)
        {
            if (pgsDeliverableHistoryDto == null) throw new ArgumentNullException(nameof(pgsDeliverableHistoryDto));
            var pgsDeliverableHistoryEntity = pgsDeliverableHistoryDto.ToEntity();
            var createdpgsDeliverableHistory = await _repository.SaveOrUpdateAsync(pgsDeliverableHistoryEntity, cancellationToken).ConfigureAwait(false);
            return new PgsDeliverableHistoryDto
            {
              

                Id = createdpgsDeliverableHistory.Id,
                PgsId = createdpgsDeliverableHistory.PgsId,
                DeliverableId = createdpgsDeliverableHistory.DeliverableId,
                DeliverableTitle = createdpgsDeliverableHistory.DeliverableTitle,
                Description = createdpgsDeliverableHistory.DeliverableTitle,
                KraId = createdpgsDeliverableHistory.KraId,
                RemovedBy = createdpgsDeliverableHistory.RemovedBy,
                RemovedAt = createdpgsDeliverableHistory.RemovedAt,
            };
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsDeliverableHistoryDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));
            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
