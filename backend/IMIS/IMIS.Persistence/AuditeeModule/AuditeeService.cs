using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditeeModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditeeModule
{
    public class AuditeeService : IAuditeeService
    {
        private readonly IAuditeeRepository _repository;

        public AuditeeService(IAuditeeRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null)
                return false;

            entity.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }

        public async Task<List<AuditeeDto>?> GetAll(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return entities?.Select(e => new AuditeeDto(e)).ToList();
        }

        public async Task<AuditeeDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new AuditeeDto(entity) : null;
        }

        public async Task<DtoPageList<AuditeeDto, Auditee, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            if (pagedEntities == null || pagedEntities.TotalCount == 0)
            {
                return null;
            }

            return DtoPageList<AuditeeDto, Auditee, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var auditeeDto = dto as AuditeeDto;
            if (auditeeDto == null) return;

            var entity = auditeeDto.ToEntity();

            if (entity.Id == 0)
            {
                _repository.Add(entity);
            }
            else
            {
                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }
    }
}