using Base.Pagination;
using Base.Primitives;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Persistence.KraRoadMapPeriodModule
{
    public class KraRoadMapPeriodService : IKraRoadMapPeriodService
    {
        private readonly IKraRoadMapPeriodRepository _repository;

        public KraRoadMapPeriodService(IKraRoadMapPeriodRepository repository)
        {
            _repository = repository;
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var kraRoadMapPeriodDto = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (kraRoadMapPeriodDto == null)
                return false;

            kraRoadMapPeriodDto.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<DtoPageList<KraRoadMapPeriodDto, KraRoadMapPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var kraRoadMapPeriodDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (kraRoadMapPeriodDto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<KraRoadMapPeriodDto, KraRoadMapPeriod, int>.Create(kraRoadMapPeriodDto.Items, page, pageSize, kraRoadMapPeriodDto.TotalCount);
        }
        public async Task<List<KraRoadMapPeriodDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var kraRoadMapPeriodDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (kraRoadMapPeriodDto == null)
                return null;

            return kraRoadMapPeriodDto.Select(d => new KraRoadMapPeriodDto(d)).ToList();
        }
        public async Task<KraRoadMapPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var period = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return period != null ? new KraRoadMapPeriodDto(period) : null;
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
       where TEntity : Entity<TId>
        {
            var ODto = dto as KraRoadMapPeriodDto;
            var kraRoadMapPeriodDto = ODto!.ToEntity();

            if (kraRoadMapPeriodDto.Id == 0)
                _repository.Add(kraRoadMapPeriodDto);
            else
                await _repository.UpdateAsync(kraRoadMapPeriodDto, kraRoadMapPeriodDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(kraRoadMapPeriodDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
