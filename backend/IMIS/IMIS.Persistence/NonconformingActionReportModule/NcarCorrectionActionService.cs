using Base.Pagination;
using Base.Primitives;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.NonconformingActionReportModule
{
    public class NcarCorrectionActionService : INcarCorrectionActionService
    {
        private readonly INcarCorrectionActionRepository _repository;

        public NcarCorrectionActionService(INcarCorrectionActionRepository repository)
        {
            _repository = repository;
        }

        public async Task<NcarCorrectionActionDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new NcarCorrectionActionDto(entity);
        }

        public async Task<bool> SaveCorrectionActionAsync(NcarCorrectionActionDto dto, CancellationToken cancellationToken)
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

        public async Task<DtoPageList<NcarCorrectionActionDto, NcarCorrectionAction, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<NcarCorrectionActionDto, NcarCorrectionAction, long>.Create(
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
            if (dto is NcarCorrectionActionDto correctionDto)
            {
                await SaveCorrectionActionAsync(correctionDto, cancellationToken).ConfigureAwait(false);
            }
        }
    }
}
