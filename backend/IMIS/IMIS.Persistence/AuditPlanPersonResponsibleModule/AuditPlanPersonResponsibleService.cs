using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanPersonResponsibleModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditPlanPersonResponsibleModule
{
    public class AuditPlanPersonResponsibleService(IAuditPlanPersonResponsibleRepository repository) : IAuditPlanPersonResponsibleService
    {
        private readonly IAuditPlanPersonResponsibleRepository _repository = repository;

        #region Retrieval Methods

        public async Task<DtoPageList<AuditPlanPersonResponsibleDto, AuditPlanPersonResponsible, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken ct)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, ct).ConfigureAwait(false);
            return DtoPageList<AuditPlanPersonResponsibleDto, AuditPlanPersonResponsible, int>.Create(result.Items, page, pageSize, result.TotalCount);
        }

        public async Task<List<AuditPlanPersonResponsibleDto>?> GetAllAsync(CancellationToken ct)
        {
            var items = await _repository.GetAllAsync(ct).ConfigureAwait(false);
            return items?.Select(x => new AuditPlanPersonResponsibleDto(x)).ToList();
        }

        public async Task<List<AuditPlanPersonResponsibleDto>?> GetActiveAsync(CancellationToken ct)
        {
            var items = await _repository.GetActiveAsync(ct).ConfigureAwait(false);
            return items?.Select(x => new AuditPlanPersonResponsibleDto(x)).ToList();
        }

        public async Task<AuditPlanPersonResponsibleDto?> GetByIdAsync(int id, CancellationToken ct)
        {
            var item = await _repository.GetByIdAsync(id, ct).ConfigureAwait(false);
            return item != null ? new AuditPlanPersonResponsibleDto(item) : null;
        }

        public async Task<List<AuditPlanPersonResponsibleDto>?> SearchByNameAsync(string name, CancellationToken ct)
        {
            if (string.IsNullOrWhiteSpace(name)) return null;
            var items = await _repository.SearchByNameAsync(name, ct).ConfigureAwait(false);
            return items?.Select(x => new AuditPlanPersonResponsibleDto(x)).ToList();
        }

        public async Task<AuditPlanPersonResponsibleDto?> GetByNameAsync(string name, CancellationToken ct)
        {
            if (string.IsNullOrWhiteSpace(name)) return null;
            var item = await _repository.GetByNameAsync(name, ct).ConfigureAwait(false);
            return item != null ? new AuditPlanPersonResponsibleDto(item) : null;
        }

        public async Task<List<AuditPlanPersonResponsibleDto>?> GetByPositionAsync(string position, CancellationToken ct)
        {
            if (string.IsNullOrWhiteSpace(position)) return null;
            var items = await _repository.GetByPositionAsync(position, ct).ConfigureAwait(false);
            return items?.Select(x => new AuditPlanPersonResponsibleDto(x)).ToList();
        }

        #endregion

        #region Command Methods

        public async Task<AuditPlanPersonResponsibleDto> CreateAsync(AuditPlanPersonResponsibleDto dto, CancellationToken ct)
        {
            ArgumentNullException.ThrowIfNull(dto);
            dto.Name = dto.Name.Trim();

            if (await _repository.ExistsByNameAsync(dto.Name, null, ct).ConfigureAwait(false))
                throw new InvalidOperationException($"A person with the name '{dto.Name}' already exists.");

            var entity = dto.ToEntity();
            entity.CreatedDate = DateTime.UtcNow;
            entity.IsActive = true;
            entity.IsDeleted = false;

            _repository.Add(entity);
            await _repository.SaveOrUpdateAsync(entity, ct).ConfigureAwait(false);

            return new AuditPlanPersonResponsibleDto(entity);
        }

        public async Task<AuditPlanPersonResponsibleDto> UpdateAsync(AuditPlanPersonResponsibleDto dto, CancellationToken ct)
        {
            ArgumentNullException.ThrowIfNull(dto);
            dto.Name = dto.Name.Trim();

            var existing = await _repository.GetByIdAsync(dto.Id, ct).ConfigureAwait(false)
                ?? throw new KeyNotFoundException($"Person with ID '{dto.Id}' not found.");

            if (await _repository.ExistsByNameAsync(dto.Name, dto.Id, ct).ConfigureAwait(false))
                throw new InvalidOperationException($"A person with the name '{dto.Name}' already exists.");

            existing.Name = dto.Name;
            existing.Position = dto.Position;
            existing.ContactInfo = dto.ContactInfo;
            existing.IsActive = dto.IsActive;

            await _repository.UpdateAsync(existing, existing.Id, ct).ConfigureAwait(false);
            await _repository.SaveOrUpdateAsync(existing, ct).ConfigureAwait(false);

            return new AuditPlanPersonResponsibleDto(existing);
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken ct)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, ct).ConfigureAwait(false);
            if (entity == null) return false;

            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(ct).ConfigureAwait(false);
            return true;
        }

        #endregion

        #region State & Validation Methods

        public async Task<bool> ActivateAsync(int id, CancellationToken ct)
        {
            var entity = await _repository.GetByIdAsync(id, ct).ConfigureAwait(false);
            if (entity == null) return false;

            entity.IsActive = true;
            await _repository.SaveOrUpdateAsync(entity, ct).ConfigureAwait(false);
            return true;
        }

        public async Task<bool> DeactivateAsync(int id, CancellationToken ct)
        {
            var entity = await _repository.GetByIdAsync(id, ct).ConfigureAwait(false);
            if (entity == null) return false;

            entity.IsActive = false;
            await _repository.SaveOrUpdateAsync(entity, ct).ConfigureAwait(false);
            return true;
        }

        public async Task<bool> ExistsByNameAsync(string name, int? excludeId = null, CancellationToken ct = default)
        {
            if (string.IsNullOrWhiteSpace(name)) return false;
            return await _repository.ExistsByNameAsync(name, excludeId, ct).ConfigureAwait(false);
        }

        /// <summary>
        /// Fixed implementation based on IsoStandardService reference
        /// </summary>
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            var ODto = dto as AuditPlanPersonResponsibleDto;
            var entity = ODto!.ToEntity();

            if (entity.Id == 0)
            {
                entity.CreatedDate = DateTime.UtcNow;
                _repository.Add(entity);
            }
            else
            {
                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
        }

        #endregion
    }
}