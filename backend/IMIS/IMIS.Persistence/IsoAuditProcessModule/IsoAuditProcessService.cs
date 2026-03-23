using Base.Pagination;
using Base.Primitives;
using IMIS.Application.IsoAuditProcessModule;
using IMIS.Domain;

namespace IMIS.Persistence.IsoAuditProcessModule
{
    public class IsoAuditProcessService : IIsoAuditProcessService
    {
        private readonly IIsoAuditProcessRepository _repository;

        public IsoAuditProcessService(IIsoAuditProcessRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null)
                return false;

            // Setting IsDeleted to true (assuming IsDeleted exists on your base Entity or shadow property)
            entity.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }

        public async Task<List<IsoAuditProcessDto>?> GetAll(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return entities?.Select(e => new IsoAuditProcessDto(e)).ToList();
        }

        public async Task<IsoAuditProcessDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new IsoAuditProcessDto(entity) : null;
        }

        public async Task<DtoPageList<IsoAuditProcessDto, IsoAuditProcess, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            if (pagedEntities == null || pagedEntities.TotalCount == 0)
            {
                return null;
            }

            return DtoPageList<IsoAuditProcessDto, IsoAuditProcess, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var processDto = dto as IsoAuditProcessDto;
            var entity = processDto!.ToEntity();

            if (entity.Id == 0)
            {
                _repository.Add(entity);
            }
            else
            {
                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            // Using the base repository's SaveOrUpdate logic to persist changes
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }
    }
}