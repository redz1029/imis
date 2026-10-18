using Base.Pagination;
using Base.Primitives;
using IMIS.Application.IsoStandardAuditPlanModule;
using IMIS.Domain;

namespace IMIS.Persistence.IsoStandardAuditPlanModule
{
    public class IsoStandardAuditPlanService : IIsoStandardAuditPlanService
    {
        private readonly IIsoStandardAuditPlanRepository _repository;

        public IsoStandardAuditPlanService(IIsoStandardAuditPlanRepository repository)
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

        public async Task<List<IsoStandardAuditPlanDto>?> GetAll(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return entities?.Select(a => new IsoStandardAuditPlanDto(a)).ToList();
        }

        public async Task<IsoStandardAuditPlanDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new IsoStandardAuditPlanDto(entity) : null;
        }

        public async Task<DtoPageList<IsoStandardAuditPlanDto, IsoStandardAuditPlan, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            if (pagedEntities.TotalCount == 0)
            {
                return null;
            }

            return DtoPageList<IsoStandardAuditPlanDto, IsoStandardAuditPlan, long>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var planDto = dto as IsoStandardAuditPlanDto;
            var entity = planDto!.ToEntity();

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