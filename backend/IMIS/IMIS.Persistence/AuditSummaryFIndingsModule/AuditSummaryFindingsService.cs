using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditSummaryFindingsModule;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditSummaryFindingsModule
{
    public class AuditSummaryFindingsService : IAuditSummaryFindingsService
    {
        private readonly IAuditSummaryFindingsRepository _repository;

        public AuditSummaryFindingsService(IAuditSummaryFindingsRepository repository)
        {
            _repository = repository;
        }

        public async Task<AuditSummaryFindingsDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new AuditSummaryFindingsDto(entity);
        }

        public async Task<bool> SaveSummaryFindingsAsync(AuditSummaryFindingsDto dto, CancellationToken cancellationToken)
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

        public async Task<DtoPageList<AuditSummaryFindingsDto, AuditSummaryFIndings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<AuditSummaryFindingsDto, AuditSummaryFIndings, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
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
            if (dto is AuditSummaryFindingsDto findingsDto)
            {
                await SaveSummaryFindingsAsync(findingsDto, cancellationToken).ConfigureAwait(false);
            }
        }
    }
}