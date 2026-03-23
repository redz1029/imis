using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Application.AuditPlanModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditPlanEntryModule
{
    public class AuditPlanEntryService(IAuditPlanEntryRepository repository) : IAuditPlanEntryService
    {
        private readonly IAuditPlanEntryRepository _repository = repository;

        public async Task<List<AuditPlanEntryDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAllAsync(cancellationToken).ConfigureAwait(false);

            return entities?.Select(e => new AuditPlanEntryDto(e)).ToList();
        }

        public async Task<List<string>> GetConflictValidationsAsync(AuditPlanEntryDto dto, CancellationToken cancellationToken)
        {
            List<string> errors = new();

            // 🔥 Example validations (you can expand this later)

            // 1. Duplicate auditors
            if (dto.IsoAuditors != null && dto.IsoAuditors.Any())
            {
                var duplicateAuditors = dto.IsoAuditors
                    .GroupBy(x => x.AuditorId)
                    .Where(g => g.Count() > 1)
                    .Select(g => g.Key);

                foreach (var auditorId in duplicateAuditors)
                {
                    errors.Add($"Duplicate auditor detected: AuditorId {auditorId}");
                }
            }

            // 2. Duplicate processes
            if (dto.AuditPlanProcesses != null && dto.AuditPlanProcesses.Any())
            {
                var duplicateProcesses = dto.AuditPlanProcesses
                    .GroupBy(x => x.AuditPlanEntryId)
                    .Where(g => g.Count() > 1)
                    .Select(g => g.Key);

                foreach (var processId in duplicateProcesses)
                {
                    errors.Add($"Duplicate process detected: ProcessId {processId}");
                }
            }

            // 3. Missing required collections
            if (dto.IsoAuditProcesses == null || !dto.IsoAuditProcesses.Any())
            {
                errors.Add("At least one ISO Audit Process is required.");
            }

            return errors;
        }
        public async Task<List<AuditPlanEntryDto>?> GetAllByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken)
        {
            var entities = await _repository
                .GetAllByAuditPlanIdAsync(auditPlanId, cancellationToken)
                .ConfigureAwait(false);

            return entities?.Select(e => new AuditPlanEntryDto(e)).ToList();
        }

        public async Task<AuditPlanEntryDto?> GetByAuditPlanEntryIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository
                .GetByAuditPlanEntryIdAsync(id, cancellationToken)
                .ConfigureAwait(false);

            return entity != null ? new AuditPlanEntryDto(entity) : null;
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

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
    where TEntity : Entity<TId>
        {
            if (dto is not AuditPlanEntryDto aDto)
                throw new InvalidOperationException("Invalid DTO type for AuditPlanEntry saving.");

            var entity = aDto.ToEntity();
            var isNew = entity.Id == 0;
            var dbContext = _repository.GetDbContext();

            // --- 1. Save or update main entity ---
            if (isNew)
            {
                dbContext.Add(entity);
                await dbContext.SaveChangesAsync(cancellationToken);
            }
            else
            {
                await _repository.UpdateAsync(entity, entity.Id, cancellationToken);
            }

            // --- 2. Handle child collections individually ---

            // IsoAuditProcesses
            if (entity.IsoAuditProcesses?.Any() == true)
            {
                var existingIds = await _repository.GetExistingIsoAuditProcessIdsAsync(entity.Id, cancellationToken);
                var newItems = entity.IsoAuditProcesses
                    .Where(x => x.Id == 0 || !existingIds.Contains(x.Id))
                    .ToList();

                if (newItems.Any())
                {
                    newItems.ForEach(x => x.AuditPlanEntryId = entity.Id);
                    await _repository.AddIsoAuditProcessesAsync(newItems, cancellationToken);
                }
            }

            // ResponsiblePersons
            if (entity.ResponsiblePersons?.Any() == true)
            {
                var existingIds = await _repository.GetExistingResponsiblePersonIdsAsync(entity.Id, cancellationToken);
                var newItems = entity.ResponsiblePersons
                    .Where(x => x.Id == 0 || !existingIds.Contains(x.Id))
                    .ToList();

                if (newItems.Any())
                {
                    newItems.ForEach(x => x.AuditPlanEntryId = entity.Id);
                    await _repository.AddResponsiblePersonsAsync(newItems, cancellationToken);
                }
            }

            // IsoAuditors
            if (entity.IsoAuditors?.Any() == true)
            {
                var existingIds = await _repository.GetExistingIsoAuditorIdsAsync(entity.Id, cancellationToken);
                var newItems = entity.IsoAuditors
                    .Where(x => x.Id == 0 || !existingIds.Contains(x.Id))
                    .ToList();

                if (newItems.Any())
                {
                    newItems.ForEach(x => x.AuditPlanEntryId = entity.Id);
                    await _repository.AddIsoAuditorsAsync(newItems, cancellationToken);
                }
            }

            // IsoStandardAuditPlans
            if (entity.IsoStandardAuditPlans?.Any() == true)
            {
                var existingIds = await _repository.GetExistingIsoStandardAuditPlanIdsAsync(entity.Id, cancellationToken);
                var newItems = entity.IsoStandardAuditPlans
                    .Where(x => x.Id == 0 || !existingIds.Contains(x.Id))
                    .ToList();

                if (newItems.Any())
                {
                    newItems.ForEach(x => x.AuditPlanEntryId = entity.Id);
                    await _repository.AddIsoStandardAuditPlansAsync(newItems, cancellationToken);
                }
            }

            // AuditPlanProcesses
            if (entity.AuditPlanProcesses?.Any() == true)
            {
                var existingIds = await _repository.GetExistingAuditPlanProcessIdsAsync(entity.Id, cancellationToken);
                var newItems = entity.AuditPlanProcesses
                    .Where(x => x.Id == 0 || !existingIds.Contains(x.Id))
                    .ToList();

                if (newItems.Any())
                {
                    newItems.ForEach(x => x.AuditPlanEntryId = entity.Id);
                    await _repository.AddAuditPlanProcessesAsync(newItems, cancellationToken);
                }
            }
        }
        public async Task<DtoPageList<AuditPlanEntryDto, AuditPlanEntry, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository
                .GetPaginatedAsync(page, pageSize, cancellationToken)
                .ConfigureAwait(false);

            if (result.TotalCount == 0)
                return null;

            return DtoPageList<AuditPlanEntryDto, AuditPlanEntry, int>
                .Create(result.Items, page, pageSize, result.TotalCount);
        }
        public async Task<bool> SaveAuditPlanEntryDetailsAsync(AuditPlanEntryDto dto, CancellationToken cancellationToken)
        {
            if (dto == null)
                return false;

            await SaveOrUpdateAsync(dto, cancellationToken);
            return true;
        }
    }
}