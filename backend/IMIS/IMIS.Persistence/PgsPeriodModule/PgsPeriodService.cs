using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Persistence.PgsPeriodModule
{
    public class PgsPeriodService : IPgsPeriodService
    {
        private readonly IPgsPeriodRepository _repository;
        
        public PgsPeriodService(IPgsPeriodRepository repository)
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
        public async Task<DtoPageList<PgsPeriodDto, PgsPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pgsPeriod = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if(pgsPeriod.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<PgsPeriodDto, PgsPeriod, int>.Create(pgsPeriod.Items, page, pageSize, pgsPeriod.TotalCount);
        }
      
        public async Task<PgsPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var period = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return period != null ? new PgsPeriodDto(period) : null;
        }
        public async Task<List<PgsPeriodDto>?> GetAllAsync(CancellationToken cancellationToken) 
        {
            var periods = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (periods == null)
                return null;

            return periods.Select(d => new PgsPeriodDto(d)).ToList();
        }       

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
        where TEntity : Entity<TId>
        {          
            var ODto = dto as PgsPeriodDto;
            var pgsPeriod = ODto!.ToEntity();

            if (pgsPeriod.Id == 0)
                _repository.Add(pgsPeriod);
            else
                await _repository.UpdateAsync(pgsPeriod, pgsPeriod.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(pgsPeriod, cancellationToken).ConfigureAwait(false);
        }      
    }
}
