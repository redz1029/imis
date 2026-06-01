using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditComFindingsModule;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditComFindingsModule
{
    public class AuditComFindingsService : IAuditComFindingsService
    {
        private readonly IAuditComFindingsRepository _repository;

        public AuditComFindingsService(IAuditComFindingsRepository repository)
        {
            _repository = repository;
        }

        public async Task<AuditComFindingsDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new AuditComFindingsDto(entity);
        }

        public async Task<bool> SaveComFindingsAsync(AuditComFindingsDto dto, CancellationToken cancellationToken)
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

        public async Task<DtoPageList<AuditComFindingsDto, AuditComFindings, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<AuditComFindingsDto, AuditComFindings, int>.Create(
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
            if (dto is AuditComFindingsDto findingsDto)
            {
                await SaveComFindingsAsync(findingsDto, cancellationToken).ConfigureAwait(false);
            }
        }
    }
}