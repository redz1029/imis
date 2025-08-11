using Base.Primitives;
using IMIS.Application.PgsDeliverableScoreHistoryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsDeliverableScoreHistoryModule
{
    public class PgsDeliverableScoreHistoryService : IPgsDeliverableScoreHistoryService
    {
        private readonly IPgsDeliverableScoreHistoryRepository _repository;
        private readonly ImisDbContext _dbContext;
        public PgsDeliverableScoreHistoryService(IPgsDeliverableScoreHistoryRepository repository, ImisDbContext dbContext)
        {
            _repository = repository;
            _dbContext = dbContext;
        }

        private PgsDeliverableScoreHistoryDto ConvPgsDeliverableScoreHistoryToDTO(PgsDeliverableScoreHistory pgsDeliverableScoreHistory)
        {
            if (pgsDeliverableScoreHistory == null) return null;

            return new PgsDeliverableScoreHistoryDto
            {
                Id = pgsDeliverableScoreHistory.Id,
                PgsDeliverableId = pgsDeliverableScoreHistory.PgsDeliverableId,
                Date = pgsDeliverableScoreHistory.Date,
                Score = pgsDeliverableScoreHistory.Score,
            };
        }
        public async Task<List<PgsDeliverableScoreHistoryGroupDto>> GetGroupedScoreHistoryAsync()
        {
            var histories = await _dbContext.PgsDeliverableScoreHistories
                .Where(x => !x.IsDeleted)
                .ToListAsync();

            var grouped = histories
                .GroupBy(h => h.PgsDeliverableId)
                .Where(g => g.Count() > 1)
                .Select(g => new PgsDeliverableScoreHistoryGroupDto
                {
                    PgsDeliverableId = g.Key,
                    ScoreHistory = g
                        .OrderBy(x => x.Date)
                        .Select(h => new PgsDeliverableScoreHistoryDto
                        {
                            Id = h.Id,
                            PgsDeliverableId = h.PgsDeliverableId,
                            Date = h.Date,
                            Score = h.Score
                        }).ToList()
                })
                .ToList();

            return grouped;
        }

        public async Task<List<PgsDeliverableScoreHistoryDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var pgsDeliverableScoreHistory = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return pgsDeliverableScoreHistory?.Select(o => ConvPgsDeliverableScoreHistoryToDTO(o)).ToList();          
        }
     
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {          
            var ODto = dto as PgsDeliverableScoreHistoryDto;
            var pgsDeliverableScoreHistoryDto = ODto!.ToEntity();

            if (pgsDeliverableScoreHistoryDto.Id == 0)
                _repository.Add(pgsDeliverableScoreHistoryDto);
            else
                await _repository.UpdateAsync(pgsDeliverableScoreHistoryDto, pgsDeliverableScoreHistoryDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(pgsDeliverableScoreHistoryDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
