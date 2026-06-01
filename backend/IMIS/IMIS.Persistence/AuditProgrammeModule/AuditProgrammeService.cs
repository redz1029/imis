using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditProgrammeModule
{
    public class AuditProgrammeService : IAuditProgrammeService
    {
        private readonly IAuditProgrammeRepository _repository;

        public AuditProgrammeService(IAuditProgrammeRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SaveAuditProgrammeAsync(AuditProgrammeDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) return false;

            var errors = await GetConflictValidationsAsync(dto, cancellationToken);
            if (errors.Any())
                throw new InvalidOperationException(string.Join(" ", errors));

            await SaveOrUpdateAsync(dto, cancellationToken);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not AuditProgrammeDto pDto)
                throw new InvalidOperationException("Invalid DTO type.");

            var entity = pDto.ToEntity();
            var dbContext = _repository.GetDbContext();

            if (entity.Id == 0)
            {
                dbContext.Add(entity);
            }
            else
            {
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken);
                if (existing == null) throw new KeyNotFoundException("Audit Programme not found.");

                // Sync Objectives: Remove existing children to ensure a clean update
                if (existing.Objectives?.Any() == true)
                {
                    _repository.RemoveObjectives(existing.Objectives.ToList());
                }

                // Update main entity values
                dbContext.Entry(existing).CurrentValues.SetValues(entity);

                // Assign new objective collection
                existing.Objectives = entity.Objectives;
            }

            await dbContext.SaveChangesAsync(cancellationToken);
        }

        public async Task<List<string>> GetConflictValidationsAsync(AuditProgrammeDto dto, CancellationToken cancellationToken)
        {
            var errors = new List<string>();

            // Validating Year range
            if (dto.Year < 2000 || dto.Year > 2100)
                errors.Add("Please provide a valid audit year.");

            // Validating mandatory collection
            if (dto.Objectives == null || !dto.Objectives.Any())
                errors.Add("An audit programme must have at least one objective.");

            // FIX: Removed ProgrammeStatus check as it does not exist in your DTO (Ref: image_9555f9.png)

            return await Task.FromResult(errors);
        }

        public async Task<DtoPageList<AuditProgrammeDto, AuditProgramme, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);

            // Fixed null check/TotalCount check to match your pattern
            if (result == null || result.TotalCount == 0) return null!;

            return DtoPageList<AuditProgrammeDto, AuditProgramme, int>.Create(result.Items, page, pageSize, result.TotalCount);
        }

        public async Task<AuditProgrammeDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken);
            return entity != null ? new AuditProgrammeDto(entity) : null;
        }

        public async Task<List<AuditProgrammeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAllAsync(cancellationToken);
            return entities?.Select(e => new AuditProgrammeDto(e)).ToList() ?? new List<AuditProgrammeDto>();
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null) return false;

            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);
            return true;
        }
    }
}