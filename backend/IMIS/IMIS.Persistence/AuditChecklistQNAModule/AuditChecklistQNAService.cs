using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditChecklistQNAModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditChecklistQNAModule
{
    public class AuditChecklistQNAService : IAuditChecklistQNAService
    {
        private readonly IAuditChecklistQNARepository _repository;

        public AuditChecklistQNAService(IAuditChecklistQNARepository repository)
        {
            _repository = repository;
        }

        public async Task<AuditChecklistQNADto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new AuditChecklistQNADto(entity);
        }

        public async Task<IEnumerable<AuditChecklistQNADto>> GetByChecklistIdAsync(int checklistId, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByChecklistIdAsync(checklistId, cancellationToken).ConfigureAwait(false);
            return entities.Select(x => new AuditChecklistQNADto(x));
        }

        public async Task<bool> SaveQNAAsync(AuditChecklistQNADto dto, CancellationToken cancellationToken)
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

            // Standard save method from your BaseRepository pattern
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task<DtoPageList<AuditChecklistQNADto, AuditChecklistQNA, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var paged = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<AuditChecklistQNADto, AuditChecklistQNA, int>.Create(
                paged.Items,
                page,
                pageSize,
                paged.TotalCount);
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return false;

            await _repository.DeleteAsync(entity, cancellationToken).ConfigureAwait(false);
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is AuditChecklistQNADto qnaDto)
            {
                await SaveQNAAsync(qnaDto, cancellationToken).ConfigureAwait(false);
            }
        }
    }
}