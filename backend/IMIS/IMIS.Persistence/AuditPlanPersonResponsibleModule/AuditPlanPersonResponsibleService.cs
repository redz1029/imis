using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanPersonResponsibleModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditPlanPersonResponsibleModule
{
    public class AuditPlanPersonResponsibleService : IAuditPlanPersonResponsibleService
    {
        private readonly IAuditPlanPersonResponsibleRepository _repository;

        public AuditPlanPersonResponsibleService(IAuditPlanPersonResponsibleRepository repository)
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

        public async Task<List<AuditPlanPersonResponsibleDto>?> GetAll(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return entities?.Select(e => new AuditPlanPersonResponsibleDto(e)).ToList();
        }

        public async Task<AuditPlanPersonResponsibleDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new AuditPlanPersonResponsibleDto(entity) : null;
        }

        public async Task<DtoPageList<AuditPlanPersonResponsibleDto, AuditPlanPersonResponsible, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            if (pagedEntities.TotalCount == 0)
            {
                return null;
            }

            return DtoPageList<AuditPlanPersonResponsibleDto, AuditPlanPersonResponsible, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var personDto = dto as AuditPlanPersonResponsibleDto;
            var entity = personDto!.ToEntity();

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