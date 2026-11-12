using Base.Pagination;
using Base.Primitives;
using IMIS.Application.StandardVersionModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.StandardVersionModule
{
    public class StandardVersionService : IStandardVersionService
    {
        private readonly IStandardVersionRepository _repository;

        public StandardVersionService(IStandardVersionRepository repository)
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

        public async Task<bool> IsInUseAsync(int id, CancellationToken cancellationToken)
        {
            return await _repository.GetDbContext().Set<IsoStandard>()
                .AsNoTracking()
                .AnyAsync(s => s.VersionID == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<bool> NameExistsAsync(string name, int exceptId, CancellationToken cancellationToken)
        {
            var wanted = (name ?? string.Empty).Trim().ToLower();
            var all = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return all.Any(v => v.Id != exceptId && (v.VersionName ?? string.Empty).Trim().ToLower() == wanted);
        }

        public async Task<List<StandardVersionDto>?> GetAll(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return entities?.Select(a => new StandardVersionDto(a)).ToList();
        }

        public async Task<StandardVersionDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new StandardVersionDto(entity) : null;
        }

        public async Task<DtoPageList<StandardVersionDto, StandardVersion, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<StandardVersionDto, StandardVersion, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var versionDto = dto as StandardVersionDto;
            var entity = versionDto!.ToEntity();

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