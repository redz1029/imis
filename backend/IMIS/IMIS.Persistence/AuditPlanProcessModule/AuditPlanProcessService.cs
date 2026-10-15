using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanProcessModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditPlanProcessModule
{
    public class AuditPlanProcessService : IAuditPlanProcessService
    {
        private readonly IAuditPlanProcessRepository _repository;

        public AuditPlanProcessService(IAuditPlanProcessRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null)
                return false;

            // Mark as deleted without physical removal
            entity.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }

        public async Task<List<AuditPlanProcessDto>?> GetAll(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return entities?.Select(e => new AuditPlanProcessDto(e)).ToList();
        }

        public async Task<AuditPlanProcessDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new AuditPlanProcessDto(entity) : null;
        }

        public async Task<DtoPageList<AuditPlanProcessDto, AuditPlanProcess, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            if (pagedEntities == null || pagedEntities.TotalCount == 0)
            {
                return null;
            }

            return DtoPageList<AuditPlanProcessDto, AuditPlanProcess, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            // Casting the generic DTO to the specific AuditPlanProcessDto
            var processDto = dto as AuditPlanProcessDto;
            if (processDto == null) return;

            var entity = processDto.ToEntity();

            if (entity.Id == 0)
            {
                _repository.Add(entity);
            }
            else
            {
                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            // Persist changes to the database
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }
    }
}