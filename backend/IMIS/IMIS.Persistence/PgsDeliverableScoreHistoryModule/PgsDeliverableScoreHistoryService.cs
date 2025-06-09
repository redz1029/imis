using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Base.Primitives;
using IMIS.Application.PgsDeliverableScoreHistoryModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Persistence.PgsDeliverableScoreHistoryModule
{
    public class PgsDeliverableScoreHistoryService : IPgsDeliverableScoreHistoryService
    {
        private readonly IPgsDeliverableScoreHistoryRepository _repository;
        public PgsDeliverableScoreHistoryService(IPgsDeliverableScoreHistoryRepository repository)
        {
            _repository = repository;
        }   
        public async Task<PgsDeliverableScoreHistoryDto> SaveOrUpdateAsync(PgsDeliverableScoreHistoryDto pgsDeliverableScoreHistoryDto, CancellationToken cancellationToken)
        {
            if (pgsDeliverableScoreHistoryDto == null) throw new ArgumentNullException(nameof(pgsDeliverableScoreHistoryDto));
            var pgsDeliverableScoreHistoryEntity = pgsDeliverableScoreHistoryDto.ToEntity();
            var createdpgsDeliverableScoreHistory = await _repository.SaveOrUpdateAsync(pgsDeliverableScoreHistoryEntity, cancellationToken).ConfigureAwait(false);
            return new PgsDeliverableScoreHistoryDto
            {
                Id = createdpgsDeliverableScoreHistory.Id,
                PgsDeliverableId = createdpgsDeliverableScoreHistory.PgsDeliverableId,
                Date = createdpgsDeliverableScoreHistory.Date,
                Score = createdpgsDeliverableScoreHistory.Score,
            };
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsDeliverableScoreHistoryDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));
            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
