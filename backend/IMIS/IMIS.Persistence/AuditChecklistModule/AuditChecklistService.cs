using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditChecklistModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditChecklistModule
{
    public class AuditChecklistService : IAuditChecklistService
    {
        private readonly IAuditChecklistRepository _repository;

        public AuditChecklistService(IAuditChecklistRepository repository)
        {
            _repository = repository;
        }

        public async Task<AuditChecklistDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new AuditChecklistDto(entity);
        }

        /// <summary>
        /// Updated to use QnAId to match the new Repository and Domain structure
        /// </summary>
        public async Task<IEnumerable<AuditChecklistDto>> GetByQnAIdAsync(int qnaId, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByQnAIdAsync(qnaId, cancellationToken).ConfigureAwait(false);
            return entities.Select(x => new AuditChecklistDto(x));
        }

        // Keep this for Interface compatibility if needed, calling the new QnA logic
        public async Task<IEnumerable<AuditChecklistDto>> GetByProcessIdAsync(int processId, CancellationToken cancellationToken)
        {
            return await GetByQnAIdAsync(processId, cancellationToken).ConfigureAwait(false);
        }

        public async Task<bool> SaveChecklistAsync(AuditChecklistDto dto, CancellationToken cancellationToken)
        {
            // Convert DTO to Entity
            var entity = dto.ToEntity();

            if (entity.Id == 0)
            {
                // Ensure required navigation properties or Foreign Keys are set before adding
                _repository.Add(entity);
            }
            else
            {
                // Fetch existing to handle RowVersion and update
                var existing = await _repository.GetByIdAsync(entity.Id, cancellationToken).ConfigureAwait(false);
                if (existing == null) return false;

                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task<DtoPageList<AuditChecklistDto, AuditChecklist, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<AuditChecklistDto, AuditChecklist, int>.Create(
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
            if (dto is AuditChecklistDto checklistDto)
            {
                await SaveChecklistAsync(checklistDto, cancellationToken).ConfigureAwait(false);
            }
        }
    }
}