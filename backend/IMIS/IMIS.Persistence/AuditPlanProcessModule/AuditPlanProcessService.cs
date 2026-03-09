using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanProcessModule;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanProcessModule
{
    public class AuditPlanProcessService : IAuditPlanProcessService
    {
        private readonly IAuditPlanProcessRepository _repository;

        public AuditPlanProcessService(IAuditPlanProcessRepository repository)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
        }

        #region READ METHODS

        public async Task<DtoPageList<AuditPlanProcessDto, AuditPlanProcess, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            if (result.TotalCount == 0)
            {
                return DtoPageList<AuditPlanProcessDto, AuditPlanProcess, int>.Create(new List<AuditPlanProcess>(), page, pageSize, 0);
            }

            return DtoPageList<AuditPlanProcessDto, AuditPlanProcess, int>.Create(result.Items, page, pageSize, result.TotalCount);
        }

        public async Task<List<AuditPlanProcessDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var processes = await _repository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            return processes?.Select(x => new AuditPlanProcessDto(x)).ToList();
        }

        public async Task<List<AuditPlanProcessDto>?> GetActiveAsync(CancellationToken cancellationToken)
        {
            var processes = await _repository.GetActiveAsync(cancellationToken).ConfigureAwait(false);
            return processes?.Select(x => new AuditPlanProcessDto(x)).ToList();
        }

        public async Task<AuditPlanProcessDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var process = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return process != null ? new AuditPlanProcessDto(process) : null;
        }

        public async Task<List<AuditPlanProcessDto>?> SearchByNameAsync(string name, CancellationToken cancellationToken)
        {
            var processes = await _repository.SearchByNameAsync(name, cancellationToken).ConfigureAwait(false);
            return processes?.Select(x => new AuditPlanProcessDto(x)).ToList();
        }

        public async Task<AuditPlanProcessDto?> GetByNameAsync(string name, CancellationToken cancellationToken)
        {
            var process = await _repository.GetByNameAsync(name, cancellationToken).ConfigureAwait(false);
            return process != null ? new AuditPlanProcessDto(process) : null;
        }

        #endregion

        #region WRITE METHODS

        public async Task<AuditPlanProcessDto> CreateAsync(AuditPlanProcessDto processDto, CancellationToken cancellationToken)
        {
            if (await _repository.ExistsByNameAsync(processDto.Name, null, cancellationToken).ConfigureAwait(false))
                throw new InvalidOperationException($"A process with the name '{processDto.Name}' already exists.");

            var process = processDto.ToEntity();
            process.CreatedDate = DateTime.UtcNow;
            process.IsActive = true;
            process.IsDeleted = false;

            // FIX: Use .Add() instead of .AddAsync(). CS1061 fixed
            _repository.Add(process);
            await _repository.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return new AuditPlanProcessDto(process);
        }

        public async Task<AuditPlanProcessDto> UpdateAsync(AuditPlanProcessDto processDto, CancellationToken cancellationToken)
        {
            var existing = await _repository.GetByIdAsync(processDto.Id, cancellationToken).ConfigureAwait(false)
                ?? throw new KeyNotFoundException($"Process with ID {processDto.Id} not found.");

            existing.Name = processDto.Name;
            existing.Description = processDto.Description;
            existing.IsActive = processDto.IsActive;
            existing.LastModifiedDate = DateTime.UtcNow;

            await _repository.UpdateAsync(existing, existing.Id, cancellationToken).ConfigureAwait(false);
            await _repository.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return new AuditPlanProcessDto(existing);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not AuditPlanProcessDto processDto) return;

            // Route to specific business logic methods to ensure timestamps/status are set
            if (EqualityComparer<TId>.Default.Equals(dto.Id, default))
            {
                await CreateAsync(processDto, cancellationToken).ConfigureAwait(false);
            }
            else
            {
                await UpdateAsync(processDto, cancellationToken).ConfigureAwait(false);
            }
        }

        #endregion

        #region UTILITY METHODS

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var process = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            if (process == null) return false;

            process.IsDeleted = true;
            await _repository.UpdateAsync(process, id, cancellationToken).ConfigureAwait(false);
            await _repository.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return true;
        }

        public async Task<bool> ActivateAsync(int id, CancellationToken cancellationToken)
        {
            var process = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            if (process == null) return false;

            process.IsActive = true;
            await _repository.UpdateAsync(process, id, cancellationToken).ConfigureAwait(false);
            await _repository.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return true;
        }

        public async Task<bool> DeactivateAsync(int id, CancellationToken cancellationToken)
        {
            var process = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            if (process == null) return false;

            process.IsActive = false;
            await _repository.UpdateAsync(process, id, cancellationToken).ConfigureAwait(false);
            await _repository.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return true;
        }

        public async Task<bool> ExistsByNameAsync(string name, int? excludeId = null, CancellationToken cancellationToken = default)
        {
            return await _repository.ExistsByNameAsync(name, excludeId, cancellationToken).ConfigureAwait(false);
        }

        #endregion
    }
}