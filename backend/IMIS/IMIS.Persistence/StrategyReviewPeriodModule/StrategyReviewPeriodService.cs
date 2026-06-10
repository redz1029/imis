using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.StrategyReviewPeriodModule;
using IMIS.Application.TeamModule;
using IMIS.Domain;

namespace IMIS.Persistence.StrategyReviewPeriodModule
{
    public class StrategyReviewPeriodService : IStrategyReviewPeriodService
    {

        private readonly IStrategyReviewPeriodRepository _repository;

        public StrategyReviewPeriodService(IStrategyReviewPeriodRepository repository)
        {
            _repository = repository;
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var period = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (period == null)
                return false;

            period.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }

        public async Task<DtoPageList<StrategyReviewPeriodDto, StrategyReviewPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var strategyReviewPeriodDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (strategyReviewPeriodDto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<StrategyReviewPeriodDto, StrategyReviewPeriod, int>.Create(strategyReviewPeriodDto.Items, page, pageSize, strategyReviewPeriodDto.TotalCount);
        }
        public async Task<StrategyReviewPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var strategyReviewPeriodDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return strategyReviewPeriodDto != null ? new StrategyReviewPeriodDto(strategyReviewPeriodDto) : null;
        }

        public async Task<List<StrategyReviewPeriodDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var strategyReviewPeriodDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (strategyReviewPeriodDto == null)
                return null;

            return strategyReviewPeriodDto.Select(d => new StrategyReviewPeriodDto(d)).ToList();
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as StrategyReviewPeriodDto;
            var strategyReviewPeriod = ODto!.ToEntity();

            if (strategyReviewPeriod.Id == 0)
                _repository.Add(strategyReviewPeriod);
            else
                await _repository.UpdateAsync(strategyReviewPeriod, strategyReviewPeriod.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(strategyReviewPeriod, cancellationToken).ConfigureAwait(false);
        }
    }
}
