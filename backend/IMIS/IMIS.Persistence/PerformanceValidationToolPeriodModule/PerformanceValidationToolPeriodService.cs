using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PerformanceValidationToolPeriodModule;
using IMIS.Domain;

namespace IMIS.Persistence.PerformanceValidationToolPeriodModule
{
    public class PerformanceValidationToolPeriodService : IPerformanceValidationToolPeriodService
    {
        
        private readonly IPerformanceValidationToolPeriodRepository _repository;

        public PerformanceValidationToolPeriodService(IPerformanceValidationToolPeriodRepository repository)
        {
            _repository = repository;
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var performanceValidationToolPeriodDto = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (performanceValidationToolPeriodDto == null)
                return false;

            performanceValidationToolPeriodDto.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<DtoPageList<PerformanceValidationToolPeriodDto, PerformanceValidationToolPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var performanceValidationToolPeriodDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (performanceValidationToolPeriodDto.TotalCount == 0)
            {
                return null!;
            }
            return DtoPageList<PerformanceValidationToolPeriodDto, PerformanceValidationToolPeriod, int>.Create(performanceValidationToolPeriodDto.Items, page, pageSize, performanceValidationToolPeriodDto.TotalCount);
        }
        public async Task<PerformanceValidationToolPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var performanceValidationToolPeriodDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return performanceValidationToolPeriodDto != null ? new PerformanceValidationToolPeriodDto(performanceValidationToolPeriodDto) : null;
        }
        public async Task<List<PerformanceValidationToolPeriodDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var performanceValidationToolPeriodDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (performanceValidationToolPeriodDto == null)
                return null;

            return performanceValidationToolPeriodDto.Select(d => new PerformanceValidationToolPeriodDto(d)).ToList();
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as PerformanceValidationToolPeriodDto;
            var performanceValidationToolPeriodDto = ODto!.ToEntity();

            if (performanceValidationToolPeriodDto.Id == 0)
                _repository.Add(performanceValidationToolPeriodDto);
            else
                await _repository.UpdateAsync(performanceValidationToolPeriodDto, performanceValidationToolPeriodDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(performanceValidationToolPeriodDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
