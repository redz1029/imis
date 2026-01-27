using Base.Pagination;
using Base.Primitives;
using IMIS.Application.StandardVersionModule;
using IMIS.Domain;

namespace IMIS.Persistence.StandardVersionModule
{
    public class StandardVersionService : IStandardVersionService
    {
        private readonly IStandardVersionRepository _repository;

        public StandardVersionService(IStandardVersionRepository repository)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
        }

        public async Task<List<StandardVersionDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var versions = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (versions == null || !versions.Any())
                return null;

            return versions.Select(v => new StandardVersionDto(v)).ToList();
        }

        public async Task<StandardVersionDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var version = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return version != null ? new StandardVersionDto(version) : null;
        }

        public async Task<StandardVersionDto?> GetByIdWithIsoStandardsAsync(int id, CancellationToken cancellationToken)
        {
            var version = await _repository.GetByIdWithIsoStandardsAsync(id, cancellationToken).ConfigureAwait(false);
            return version != null ? new StandardVersionDto(version) : null;
        }

        public async Task<List<StandardVersionDto>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken)
        {
            var versions = await _repository.FilterByName(name, noOfResults, cancellationToken).ConfigureAwait(false);
            return versions != null && versions.Any() ? versions.Select(v => new StandardVersionDto(v)).ToList() : null;
        }

        public async Task<DtoPageList<StandardVersionDto, StandardVersion, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var versions = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (versions.TotalCount == 0)
                return null;
            return DtoPageList<StandardVersionDto, StandardVersion, int>.Create(versions.Items, page, pageSize, versions.TotalCount);
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var version = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (version == null)
                return false;

            version.isActive = false;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }

        public async Task SaveOrUpdateAsync(StandardVersionDto dto, CancellationToken cancellationToken)
        {
            if (dto == null)
                throw new ArgumentNullException(nameof(dto));

            var entity = dto.ToEntity();

            if (entity.Id == 0)
                _repository.Add(entity);
            else
                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is StandardVersionDto versionDto)
            {
                await SaveOrUpdateAsync(versionDto, cancellationToken).ConfigureAwait(false);
            }
        }
    }
}
