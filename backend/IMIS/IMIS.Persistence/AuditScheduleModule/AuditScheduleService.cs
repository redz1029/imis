using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditScheduleModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditScheduleModule
{
    public class AuditScheduleService : IAuditScheduleService
    {
        private readonly IAuditScheduleRepository _repository;

        public AuditScheduleService(IAuditScheduleRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SaveAuditScheduleAsync(AuditScheduleDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) return false;
            await SaveOrUpdateAsync(dto, cancellationToken);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not AuditScheduleDto sDto)
                throw new InvalidOperationException("Invalid DTO type.");

            var entity = sDto.ToEntity();
            var dbContext = _repository.GetDbContext();

            // 1️⃣ Handle Main Entity Persistence
            if (entity.Id == 0)
            {
                dbContext.Add(entity);
            }
            else
            {
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken);
                if (existing != null)
                {
                    // Update main properties on the tracked existing entity
                    existing.Purpose = entity.Purpose;
                    existing.AuditTitle = entity.AuditTitle;
                    existing.IsActive = entity.IsActive;
                    existing.AuditorTeams = entity.AuditorTeams;

                    // Remove old children to avoid FK conflicts/duplicates during replacement
                    if (existing.AuditableOffices?.Any() == true)
                        dbContext.Set<AuditableOffices>().RemoveRange(existing.AuditableOffices);

                    if (existing.AuditSchduleDetails?.Any() == true)
                        dbContext.Set<AuditScheduleDetails>().RemoveRange(existing.AuditSchduleDetails);

                    // Re-add new collections from the entity
                    existing.AuditableOffices = entity.AuditableOffices;
                    existing.AuditSchduleDetails = entity.AuditSchduleDetails;
                }
            }

            await dbContext.SaveChangesAsync(cancellationToken);
        }

        public async Task<List<AuditScheduleDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAllAsync(cancellationToken);
            return entities?.Select(e => new AuditScheduleDto(e)).ToList();
        }

        public async Task<AuditScheduleDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken);
            return entity != null ? new AuditScheduleDto(entity) : null;
        }

        public async Task<List<string>> GetConflictValidationsAsync(AuditScheduleDto dto, CancellationToken cancellationToken)
        {
            var errors = new List<string>();

            if (string.IsNullOrWhiteSpace(dto.Purpose))
                errors.Add("Purpose is required.");

            if (string.IsNullOrWhiteSpace(dto.AuditTitle))
                errors.Add("Audit Title is required.");

            return await Task.FromResult(errors);
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null) return false;

            // Assuming AuditSchedule has an IsDeleted property or similar logic
            // If it uses the IsActive property for soft deletes:
            entity.IsActive = false;

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);
            return true;
        }

        public async Task<DtoPageList<AuditScheduleDto, AuditSchedule, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            if (result.TotalCount == 0) return null;

            return DtoPageList<AuditScheduleDto, AuditSchedule, int>.Create(result.Items, page, pageSize, result.TotalCount);
        }
    }
}