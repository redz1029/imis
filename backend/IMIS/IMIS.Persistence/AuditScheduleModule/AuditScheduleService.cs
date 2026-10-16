using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.IQASignatoryModule;
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

        public async Task<bool> SaveAuditScheduleAsync(AuditScheduleDto dto, CancellationToken cancellationToken, string? userId = null)
        {
            if (dto == null) return false;
            await SaveOrUpdateInternalAsync(dto, cancellationToken, userId);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            await SaveOrUpdateInternalAsync(dto, cancellationToken, userId: null);
        }

        private async Task SaveOrUpdateInternalAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken, string? userId)
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
                await dbContext.SaveChangesAsync(cancellationToken);

                // Audit Schedule has NO Draft status — immediately initialized as Pending Confirmation.
                // The actor id (JWT user) is threaded through so the workflow
                // rows reference a real AspNetUsers row instead of a
                // placeholder that violates the FK (DbUpdateException 547).
                await IQAApprovalWorkflow.SubmitAsync(
                    dbContext, IQAApprovalWorkflow.EntityTypes.AuditSchedule, entity.Id,
                    "audit schedule", userId, null, cancellationToken);
                await dbContext.SaveChangesAsync(cancellationToken);

                // CRITICAL: surface the EF-generated identity on the DTO so the
                // caller (POST endpoint / frontend) receives the real Id instead
                // of 0. Without this the client cannot submit/confirm the new
                // schedule and the confirmation silently no-ops.
                sDto.Id = entity.Id;
                return;
            }
            else
            {
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken);
                if (existing != null)
                {
                    // Update main properties on the tracked existing entity
                    existing.Purpose = entity.Purpose;
                    existing.Activity = entity.Activity;
                    existing.IsActive = entity.IsActive;

                    // FIX: was existing.AuditorTeams = entity.AuditorTeams —
                    // that property no longer exists on AuditSchedule.
                    existing.TeamId = entity.TeamId;

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

        public async Task<List<AuditScheduleDto>> GetConfirmedAsync(CancellationToken cancellationToken)
        {
            var all = await GetAllAsync(cancellationToken);
            return all?.Where(s => s.StatusCode == IQAApprovalWorkflow.StateCodes.Confirmed ||
                                   s.StatusCode == IQAApprovalWorkflow.StateCodes.Approved).ToList()
                   ?? new List<AuditScheduleDto>();
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

            if (string.IsNullOrWhiteSpace(dto.Activity))
                errors.Add("Audit Title is required.");

            // Gating Rule: Verify the parent Audit Plan is APPROVED
            if (dto.AuditPlanId > 0)
            {
                var dbContext = _repository.GetDbContext();
                var planState = await IQAApprovalWorkflow.GetStateCodeAsync(
                    dbContext, IQAApprovalWorkflow.EntityTypes.AuditPlan, dto.AuditPlanId, cancellationToken);

                if (planState != IQAApprovalWorkflow.StateCodes.Approved)
                {
                    errors.Add("An Audit Schedule can only be created for an APPROVED Audit Plan.");
                }
            }

            return errors;
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

        public async Task<IEnumerable<AuditScheduleDto>> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByAuditPlanIdAsync(auditPlanId, cancellationToken);
            return entities.Select(x => new AuditScheduleDto(x));
        }

        public async Task<IEnumerable<AuditScheduleDto>> GetByAuditPlanEntryIdAsync(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByAuditPlanEntryIdAsync(auditPlanEntryId, cancellationToken);
            return entities.Select(x => new AuditScheduleDto(x));
        }
        public async Task<ReportAuditScheduleDto?> ReportGetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new ReportAuditScheduleDto(entity) : null;
        }

        public async Task<(bool Success, string? Error)> SubmitAsync(int id, CancellationToken cancellationToken)
        {
            return await SubmitAsync(id, null, null, cancellationToken);
        }

        public async Task<(bool Success, string? Error)> SubmitAsync(
            int id, string? userId, string? comments, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var entity = await dbContext.Set<AuditSchedule>()
                .FirstOrDefaultAsync(x => x.Id == id && x.IsActive, cancellationToken);

            if (entity == null)
                return (false, "Audit schedule not found.");

            if (string.IsNullOrWhiteSpace(entity.Purpose) || string.IsNullOrWhiteSpace(entity.Activity))
                return (false, "Purpose and Activity are required before submitting.");

            var result = await IQAApprovalWorkflow.SubmitAsync(
                dbContext, IQAApprovalWorkflow.EntityTypes.AuditSchedule, entity.Id,
                "audit schedule", userId, comments, cancellationToken);
            if (!result.Success) return result;

            return await SaveWorkflowChangesAsync(dbContext, cancellationToken);
        }

        public async Task<(bool Success, string? Error)> DecideAsync(
            int id, string approverId, bool approve, string? comments, CancellationToken cancellationToken)
        {
            return await DecideAsync(id, approverId, approve ? "Confirm" : "Reject", comments, null, cancellationToken);
        }

        public async Task<(bool Success, string? Error)> DecideAsync(
            int id, string approverId, string action, string? comments, string? officeName, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(approverId))
                return (false, "Approver is required.");

            var dbContext = _repository.GetDbContext();

            var entity = await dbContext.Set<AuditSchedule>()
                .Include(s => s.AuditableOffices!)
                    .ThenInclude(ao => ao.Office)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

            if (entity == null)
                return (false, "Audit schedule not found.");

            string? resolvedOfficeName = officeName ?? entity.AuditableOffices?.FirstOrDefault()?.Office?.Name;

            var result = await IQAApprovalWorkflow.DecideAsync(
                dbContext, IQAApprovalWorkflow.EntityTypes.AuditSchedule, entity.Id,
                "audit schedule", approverId, action, comments, resolvedOfficeName, cancellationToken);

            if (!result.Success) return result;

            return await SaveWorkflowChangesAsync(dbContext, cancellationToken);
        }

        private static async Task<(bool Success, string? Error)> SaveWorkflowChangesAsync(
            DbContext dbContext, CancellationToken cancellationToken)
        {
            try
            {
                await dbContext.SaveChangesAsync(cancellationToken);
                return (true, null);
            }
            catch (DbUpdateConcurrencyException)
            {
                return (false, "This audit schedule was changed by someone else. Please refresh and try again.");
            }
        }
    }
}
