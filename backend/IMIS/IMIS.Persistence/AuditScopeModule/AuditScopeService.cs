using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditScopeModule;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditScopeModule
{
    public class AuditScopeService : IAuditScopeService
    {
        private readonly IAuditScopeRepository _repository;

        public AuditScopeService(IAuditScopeRepository repository)
        {
            _repository = repository;
        }

        public async Task<AuditScopeDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new AuditScopeDto(entity);
        }

        public async Task<bool> SaveAuditScopeAsync(AuditScopeDto dto, CancellationToken cancellationToken)
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

        public async Task<DtoPageList<AuditScopeDto, AuditScope, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<AuditScopeDto, AuditScope, int>.Create(
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
            if (dto is AuditScopeDto auditScopeDto)
            {
                await SaveAuditScopeAsync(auditScopeDto, cancellationToken).ConfigureAwait(false);
            }
        }
    }
}