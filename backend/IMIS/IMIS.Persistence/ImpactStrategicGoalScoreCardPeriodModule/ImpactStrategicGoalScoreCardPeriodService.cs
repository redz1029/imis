using Base.Pagination;
using Base.Primitives;
using IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule;
using IMIS.Domain;

namespace IMIS.Persistence.ImpactStrategicGoalScoreCardPeriodModule
{
    public class ImpactStrategicGoalScoreCardPeriodService : IImpactStrategicGoalScoreCardPeriodService
    {
        private readonly IImpactStrategicGoalScoreCardPeriodRepository _repository;

        public ImpactStrategicGoalScoreCardPeriodService(IImpactStrategicGoalScoreCardPeriodRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var impactStrategicGoalScoreCardPeriodDto = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (impactStrategicGoalScoreCardPeriodDto == null)
                return false;

            impactStrategicGoalScoreCardPeriodDto.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }

        public async Task<DtoPageList<ImpactStrategicGoalScoreCardPeriodDto, ImpactStrategicGoalScoreCardPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var impactStrategicGoalScoreCardPeriodDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (impactStrategicGoalScoreCardPeriodDto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<ImpactStrategicGoalScoreCardPeriodDto, ImpactStrategicGoalScoreCardPeriod, int>.Create(impactStrategicGoalScoreCardPeriodDto.Items, page, pageSize, impactStrategicGoalScoreCardPeriodDto.TotalCount);
        }
        public async Task<ImpactStrategicGoalScoreCardPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var period = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return period != null ? new ImpactStrategicGoalScoreCardPeriodDto(period) : null;
        }
        public async Task<List<ImpactStrategicGoalScoreCardPeriodDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var impactStrategicGoalScoreCardPeriods = await _repository
                .GetAll(cancellationToken)
                .ConfigureAwait(false);

            if (impactStrategicGoalScoreCardPeriods == null)
                return null;

            return impactStrategicGoalScoreCardPeriods.Select(d => new ImpactStrategicGoalScoreCardPeriodDto(d)).ToList();
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as ImpactStrategicGoalScoreCardPeriodDto;
            var impactStrategicGoalScoreCardPeriodDto = ODto!.ToEntity();

            if (impactStrategicGoalScoreCardPeriodDto.Id == 0)
                _repository.Add(impactStrategicGoalScoreCardPeriodDto);
            else
                await _repository.UpdateAsync(impactStrategicGoalScoreCardPeriodDto, impactStrategicGoalScoreCardPeriodDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(impactStrategicGoalScoreCardPeriodDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
