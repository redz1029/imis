using Base.Primitives;
using IMIS.Application.PgsDeliverableHistoryModule;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using VaultSharp.V1.SecretsEngines.Identity;

namespace IMIS.Persistence.PgsDeliverableHistoryModule
{
    public class PgsDeliverableHistoryService : IPgsDeliverableHistoryService
    {
        private readonly IPgsDeliverableHistoryRepository _repository;
        public PgsDeliverableHistoryService(IPgsDeliverableHistoryRepository repository)
        {
            _repository = repository;           
        }

       
        public async Task<List<PgsDeliverableHistoryDto>?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pgsList = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);

            if (pgsList == null || !pgsList.Any())
                return null;
            var result = pgsList
               .Select(p => new PgsDeliverableHistoryDto
               {
                   Id = p.Id,
                   PgsId = p.PgsId,
                   DeliverableId = p.DeliverableId,
                   DeliverableName = p.DeliverableName,
                   KraDescription = p.KraDescription,
                   KraId = p.KraId,
                   DisapprovalRemarks = p.DisapprovalRemarks,
                   IsDisapproved = p.IsDisapproved,
                   IsDirect = p.IsDirect,
                   PercentDeliverables = p.PercentDeliverables,
                   ByWhen = p.ByWhen,
                   Status = p.Status,
                   Remarks = p.Remarks,
                   RemovedBy = p.RemovedBy,
                   RemovedAt = p.RemovedAt
               }).ToList();

            return result!;
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
                DeliverableName = createdpgsDeliverableHistory.DeliverableName,
                KraDescription = createdpgsDeliverableHistory.KraDescription,
                KraId = createdpgsDeliverableHistory.KraId,
                DisapprovalRemarks = createdpgsDeliverableHistory.DisapprovalRemarks,
                IsDirect = createdpgsDeliverableHistory.IsDirect,
                PercentDeliverables = createdpgsDeliverableHistory.PercentDeliverables,
                ByWhen = createdpgsDeliverableHistory.ByWhen,
                Status = createdpgsDeliverableHistory.Status,
                Remarks = createdpgsDeliverableHistory.Remarks,
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
