using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditPlanModule
{
    public class AuditPlanService : IAuditPlanService
    {
        private readonly IAuditPlanRepository _repository;

        public AuditPlanService(IAuditPlanRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SaveAuditPlanAsync(AuditPlanDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) return false;
            await SaveOrUpdateAsync(dto, cancellationToken);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
    where TEntity : Entity<TId>
        {
            if (dto is not AuditPlanDto aDto)
                throw new InvalidOperationException("Invalid DTO type.");

            var entity = aDto.ToEntity();
            var dbContext = _repository.GetDbContext();

            // 1️⃣ Save main AuditPlan first
            if (entity.Id == 0)
            {
                dbContext.Add(entity);
                await dbContext.SaveChangesAsync(cancellationToken); // EF will handle transaction
            }
            else
            {
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken);
                if (existing != null)
                {
                    // Remove old children first to avoid FK conflicts
                    if (existing.Entries?.Any() == true)
                        dbContext.Set<AuditPlanEntry>().RemoveRange(existing.Entries);

                    if (existing.Approvals?.Any() == true)
                        dbContext.Set<AuditPlanApproval>().RemoveRange(existing.Approvals);

                    await dbContext.SaveChangesAsync(cancellationToken);

                    // Update main entity
                    await _repository.UpdateAsync(entity, entity.Id, cancellationToken);
                }
            }

            // 2️⃣ Save AuditPlanEntries
            if (entity.Entries?.Any() == true)
            {
                foreach (var entry in entity.Entries)
                {
                    entry.AuditPlanId = entity.Id; // FK must exist
                    dbContext.Set<AuditPlanEntry>().Add(entry);
                }
                await dbContext.SaveChangesAsync(cancellationToken);

                // 3️⃣ Save nested children for each entry
                foreach (var entry in entity.Entries)
                {
                    if (entry.IsoAuditors?.Any() == true)
                    {
                        foreach (var auditor in entry.IsoAuditors)
                            auditor.AuditPlanEntryId = entry.Id;
                        dbContext.Set<IsoAuditor>().AddRange(entry.IsoAuditors);
                    }

                    if (entry.ResponsiblePersons?.Any() == true)
                    {
                        foreach (var person in entry.ResponsiblePersons)
                            person.AuditPlanEntryId = entry.Id;
                        dbContext.Set<AuditPlanPersonResponsible>().AddRange(entry.ResponsiblePersons);
                    }

                    if (entry.IsoAuditProcesses?.Any() == true)
                    {
                        foreach (var process in entry.IsoAuditProcesses)
                            process.AuditPlanEntryId = entry.Id;
                        dbContext.Set<IsoAuditProcess>().AddRange(entry.IsoAuditProcesses);
                    }

                    if (entry.IsoStandardAuditPlans?.Any() == true)
                    {
                        foreach (var plan in entry.IsoStandardAuditPlans)
                            plan.AuditPlanEntryId = entry.Id;
                        dbContext.Set<IsoStandardAuditPlan>().AddRange(entry.IsoStandardAuditPlans);
                    }

                    if (entry.AuditPlanProcesses?.Any() == true)
                    {
                        foreach (var planProcess in entry.AuditPlanProcesses)
                            planProcess.AuditPlanEntryId = entry.Id;
                        dbContext.Set<AuditPlanProcess>().AddRange(entry.AuditPlanProcesses);
                    }
                }

                await dbContext.SaveChangesAsync(cancellationToken);
            }

            // 4️⃣ Save Approvals
            if (entity.Approvals?.Any() == true)
            {
                foreach (var approval in entity.Approvals)
                    approval.AuditPlanId = entity.Id;

                dbContext.Set<AuditPlanApproval>().AddRange(entity.Approvals);
                await dbContext.SaveChangesAsync(cancellationToken);
            }
        }
        // Other retrieval methods...
        public async Task<List<AuditPlanDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAllAsync(cancellationToken);
            return entities?.Select(e => new AuditPlanDto(e)).ToList();
        }

        public async Task<AuditPlanDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken);
            return entity != null ? new AuditPlanDto(entity) : null;
        }

        public async Task<List<string>> GetConflictValidationsAsync(AuditPlanDto dto, CancellationToken cancellationToken)
        {
            var errors = new List<string>();
            if (dto.StartDate > dto.EndDate)
                errors.Add("Start date cannot be greater than end date.");
            if (string.IsNullOrWhiteSpace(dto.PlanStatus))
                errors.Add("PlanStatus is required.");
            if (dto.Entries == null || !dto.Entries.Any())
                errors.Add("At least one Audit Plan Entry is required.");
            return errors;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null) return false;
            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);
            return true;
        }

        public async Task<DtoPageList<AuditPlanDto, AuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            if (result.TotalCount == 0) return null;
            return DtoPageList<AuditPlanDto, AuditPlan, int>.Create(result.Items, page, pageSize, result.TotalCount);
        }
    }
}