using Base.Pagination;
using Base.Primitives;
using IMIS.Application.IsoAuditorModule;
using IMIS.Domain;

namespace IMIS.Persistence.IsoAuditorModule
{
    public class IsoAuditorService : IIsoAuditorService
    {
        private readonly IIsoAuditorRepository _isoAuditorRepository;

        public IsoAuditorService(IIsoAuditorRepository isoAuditorRepository)
        {
            _isoAuditorRepository = isoAuditorRepository;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _isoAuditorRepository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null)
                return false;

            entity.IsDeleted = true;

            var context = _isoAuditorRepository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }

        public async Task<List<IsoAuditorDto>?> GetAll(CancellationToken cancellationToken)
        {
            var entities = await _isoAuditorRepository.GetAll(cancellationToken).ConfigureAwait(false);
            return entities?.Select(e => new IsoAuditorDto(e)).ToList();
        }

        public async Task<IsoAuditorDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _isoAuditorRepository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new IsoAuditorDto(entity) : null;
        }

        public async Task<DtoPageList<IsoAuditorDto, IsoAuditor, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _isoAuditorRepository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            if (pagedEntities.TotalCount == 0)
            {
                return null;
            }

            return DtoPageList<IsoAuditorDto, IsoAuditor, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var auditorDto = dto as IsoAuditorDto;
            var entity = auditorDto!.ToEntity();

            if (entity.Id == 0)
            {
                _isoAuditorRepository.Add(entity);
            }
            else
            {
                await _isoAuditorRepository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            await _isoAuditorRepository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }
    }
}