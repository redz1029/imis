using Base.Pagination;
using Base.Primitives;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.NonconformingActionReportModule
{
    public class NcarRootCauseService : INcarRootCauseService
    {
        private readonly INcarRootCauseRepository _repository;

        public NcarRootCauseService(INcarRootCauseRepository repository)
        {
            _repository = repository;
        }

        public async Task<NcarRootCauseDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new NcarRootCauseDto(entity);
        }

        public async Task<bool> SaveRootCauseAsync(NcarRootCauseDto dto, CancellationToken cancellationToken)
        {
            var entity = dto.ToEntity();

            if (entity.Id == 0)
            {
                _repository.Add(entity);
            }
            else
            {
                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task<DtoPageList<NcarRootCauseDto, NcarRootCause, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<NcarRootCauseDto, NcarRootCause, long>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task<bool> SoftDeleteAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return false;

            await _repository.DeleteAsync(entity, cancellationToken).ConfigureAwait(false);
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);

            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is NcarRootCauseDto rootCauseDto)
            {
                await SaveRootCauseAsync(rootCauseDto, cancellationToken).ConfigureAwait(false);
            }
        }
    }
}
