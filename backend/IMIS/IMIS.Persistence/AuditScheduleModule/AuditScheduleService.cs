using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.IQASignatoryModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;
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
                // The actor id (JWT user) is threaded through so the workflow//
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

        public async Task<(bool Success, string? Error)> RescheduleAsync(
            int id, DateTime proposedDate, string? comments, CancellationToken cancellationToken)
        {
            // Reschedule keeps the audit plan entry's time; only the date moves.
            var moved = await MoveScheduleAsync(id, proposedDate.Date, null, cancellationToken);
            if (!moved.Success) return moved;

            return await SaveWorkflowChangesAsync(_repository.GetDbContext(), cancellationToken);
        }

        /// <summary>
        /// Validates the proposed date/time against the audit plan and the
        /// auditee office's other schedules. Returns an error message, or null.
        /// </summary>
        private static async Task<string?> ValidateProposedMoveAsync(
            DbContext dbContext, AuditSchedule schedule, AuditPlan plan,
            DateTime date, TimeSpan time, CancellationToken cancellationToken)
        {
            if (date < plan.StartDate.Date || date > plan.EndDate.Date)
                return "The selected date is outside the audit plan schedule.";

            // Same-day, same-time conflict check for the same auditee office.
            var officeId = schedule.AuditableOffices
                ?.Where(ao => !ao.IsDeleted)
                .Select(ao => ao.OfficeId)
                .FirstOrDefault();

            if (officeId.HasValue)
            {
                var conflict = await dbContext.Set<AuditSchedule>()
                    .Include(s => s.AuditableOffices!)
                    .AnyAsync(s => s.Id != schedule.Id && s.IsActive &&
                        s.AuditableOffices!.Any(ao => !ao.IsDeleted && ao.OfficeId == officeId.Value) &&
                        s.StartDate.Date == date &&
                        s.StartDate.TimeOfDay == time, cancellationToken);

                if (conflict)
                    return "The selected time is not available on that day for this office. Please choose another time or day.";
            }

            return null;
        }

        /// <summary>
        /// Applies a new date (and optionally time) to the schedule, its audit
        /// plan entry and the revision counters. Does NOT save, so callers can
        /// persist it together with their own changes.
        /// </summary>
        private async Task<(bool Success, string? Error)> MoveScheduleAsync(
            int id, DateTime date, TimeSpan? time, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var entity = await dbContext.Set<AuditSchedule>()
                .Include(s => s.AuditableOffices!)
                    .ThenInclude(ao => ao.Office)
                .Include(s => s.AuditPlanEntry!)
                .FirstOrDefaultAsync(x => x.Id == id && x.IsActive, cancellationToken);

            if (entity == null)
                return (false, "Audit schedule not found.");

            var entry = entity.AuditPlanEntry;
            if (entry == null)
                return (false, "Audit schedule has no linked audit plan entry.");

            var plan = await dbContext.Set<AuditPlan>()
                .FirstOrDefaultAsync(p => p.Id == entity.AuditPlanId, cancellationToken);
            if (plan == null)
                return (false, "Audit plan not found.");

            var newTime = time ?? entry.Time.TimeOfDay;
            var error = await ValidateProposedMoveAsync(dbContext, entity, plan, date, newTime, cancellationToken);
            if (error != null)
                return (false, error);

            var proposed = date + newTime;
            var dayNumber = (date - plan.StartDate.Date).Days + 1;
            var dayChanged = dayNumber != entry.DayNumber;

            // The audit plan entry is the source of the day and the time.
            entry.DayNumber = dayNumber;
            entry.Time = entry.Time.Date + newTime;

            entity.StartDate = proposed;
            entity.EndDate = proposed;

            // Time-only change (same day) revises the Audit Plan only. A day
            // change revises the Audit Plan and its parent Audit Programme.
            plan.Revision += 1;
            plan.LastModifiedDate = DateTime.UtcNow;

            if (dayChanged)
            {
                var programme = await dbContext.Set<AuditProgramme>()
                    .FirstOrDefaultAsync(p => p.Id == plan.AuditProgrammeId, cancellationToken);
                if (programme != null)
                {
                    programme.Revision += 1;
                    programme.LastModifiedDate = DateTime.UtcNow;
                }
            }

            return (true, null);
        }

        // ------------------------------------------------------------------
        // Reschedule request workflow: Department Head -> Auditor Team Leader
        // -> Lead Auditor -> automatic Audit Plan / Audit Programme revision.
        // ------------------------------------------------------------------
        private const string TeamLeaderRoleName = "Auditor Team Leader";
        private const string LeadAuditorRoleName = "Lead Auditor";
        private const string AdministratorRoleName = "Administrator";

        private static bool IsPending(string status) =>
            status == AuditScheduleRescheduleRequest.Statuses.PendingTeamLeader ||
            status == AuditScheduleRescheduleRequest.Statuses.PendingLeadAuditor;

        private static Task<bool> IsInRoleAsync(
            DbContext dbContext, string userId, string roleName, CancellationToken cancellationToken)
        {
            return (from ur in dbContext.Set<IdentityUserRole<string>>()
                    join r in dbContext.Set<IdentityRole>() on ur.RoleId equals r.Id
                    where ur.UserId == userId && r.Name == roleName
                    select ur.UserId).AnyAsync(cancellationToken);
        }

        private static async Task<bool> IsTeamLeaderForAsync(
            DbContext dbContext, string userId, AuditSchedule schedule, CancellationToken cancellationToken)
        {
            var teamIds = await dbContext.Set<IsoAuditor>()
                .Where(a => !a.IsDeleted && a.AuditPlanEntryId == schedule.AuditPlanEntryId && a.TeamId != null)
                .Select(a => a.TeamId!.Value)
                .ToListAsync(cancellationToken);
            if (schedule.TeamId.HasValue)
                teamIds.Add(schedule.TeamId.Value);

            // No team could be resolved for the schedule: fall back to the role.
            if (teamIds.Count == 0)
                return await IsInRoleAsync(dbContext, userId, TeamLeaderRoleName, cancellationToken);

            return await dbContext.Set<AuditorTeams>()
                .AnyAsync(t => !t.IsDeleted && t.IsTeamLeader && teamIds.Contains(t.TeamId) &&
                               t.Auditor != null && t.Auditor.UserId == userId, cancellationToken);
        }

        private static async Task<bool> CanDecideAsync(
            DbContext dbContext, string? userId, AuditScheduleRescheduleRequest request, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(userId) || request.AuditSchedule == null)
                return false;

            // Administrators can do everything in IQA.
            if (IsPending(request.Status) &&
                await IsInRoleAsync(dbContext, userId, AdministratorRoleName, cancellationToken))
                return true;

            if (request.Status == AuditScheduleRescheduleRequest.Statuses.PendingTeamLeader)
                return await IsTeamLeaderForAsync(dbContext, userId, request.AuditSchedule, cancellationToken);

            if (request.Status == AuditScheduleRescheduleRequest.Statuses.PendingLeadAuditor)
                return await IsInRoleAsync(dbContext, userId, LeadAuditorRoleName, cancellationToken);

            return false;
        }

        private static IQueryable<AuditScheduleRescheduleRequest> RequestsWithSchedule(DbContext dbContext) =>
            dbContext.Set<AuditScheduleRescheduleRequest>()
                .Include(r => r.AuditSchedule!)
                    .ThenInclude(s => s.AuditableOffices!)
                        .ThenInclude(ao => ao.Office);

        private static async Task<List<AuditScheduleRescheduleRequestDto>> ToRequestDtosAsync(
            DbContext dbContext, List<AuditScheduleRescheduleRequest> requests, string? userId,
            bool onlyDecidable, CancellationToken cancellationToken)
        {
            var requesterIds = requests
                .Select(r => r.RequestedByUserId)
                .Where(u => !string.IsNullOrWhiteSpace(u))
                .Select(u => u!)
                .Distinct()
                .ToList();
            var names = requesterIds.Count == 0
                ? new Dictionary<string, string?>()
                : await dbContext.Set<User>()
                    .Where(u => requesterIds.Contains(u.Id))
                    .ToDictionaryAsync(u => u.Id, u => u.UserName, cancellationToken);

            var list = new List<AuditScheduleRescheduleRequestDto>();
            foreach (var r in requests)
            {
                var canDecide = await CanDecideAsync(dbContext, userId, r, cancellationToken);
                if (onlyDecidable && !canDecide) continue;

                string? requester = null;
                if (r.RequestedByUserId != null)
                    names.TryGetValue(r.RequestedByUserId, out requester);

                list.Add(new AuditScheduleRescheduleRequestDto
                {
                    Id = r.Id,
                    AuditScheduleId = r.AuditScheduleId,
                    AuditPlanId = r.AuditSchedule?.AuditPlanId ?? 0,
                    OfficeName = r.AuditSchedule?.AuditableOffices
                        ?.FirstOrDefault(ao => !ao.IsDeleted)?.Office?.Name,
                    CurrentStartDate = r.AuditSchedule?.StartDate ?? default,
                    ProposedStartDate = r.ProposedStartDate,
                    Reason = r.Reason,
                    Status = r.Status,
                    RequestedBy = requester,
                    RequestedDate = r.RequestedDate,
                    TeamLeaderRemarks = r.TeamLeaderRemarks,
                    LeadAuditorRemarks = r.LeadAuditorRemarks,
                    CanDecide = canDecide
                });
            }
            return list;
        }

        public async Task<(bool Success, string? Error)> RequestRescheduleAsync(
            int id, DateTime proposedStart, string? reason, string? userId, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var schedule = await dbContext.Set<AuditSchedule>()
                .Include(s => s.AuditableOffices!)
                    .ThenInclude(ao => ao.Office)
                .Include(s => s.AuditPlanEntry!)
                .FirstOrDefaultAsync(x => x.Id == id && x.IsActive, cancellationToken);
            if (schedule == null)
                return (false, "Audit schedule not found.");

            var entry = schedule.AuditPlanEntry;
            if (entry == null)
                return (false, "Audit schedule has no linked audit plan entry.");

            var plan = await dbContext.Set<AuditPlan>()
                .FirstOrDefaultAsync(p => p.Id == schedule.AuditPlanId, cancellationToken);
            if (plan == null)
                return (false, "Audit plan not found.");

            var alreadyPending = await dbContext.Set<AuditScheduleRescheduleRequest>()
                .AnyAsync(r => r.AuditScheduleId == id && !r.IsDeleted &&
                    (r.Status == AuditScheduleRescheduleRequest.Statuses.PendingTeamLeader ||
                     r.Status == AuditScheduleRescheduleRequest.Statuses.PendingLeadAuditor), cancellationToken);
            if (alreadyPending)
                return (false, "A reschedule request for this audit schedule is already awaiting a decision.");

            var date = proposedStart.Date;
            var time = proposedStart.TimeOfDay;
            var currentDate = plan.StartDate.Date.AddDays(entry.DayNumber - 1);
            if (date == currentDate && time == entry.Time.TimeOfDay)
                return (false, "The requested schedule is the same as the current schedule.");

            var error = await ValidateProposedMoveAsync(dbContext, schedule, plan, date, time, cancellationToken);
            if (error != null)
                return (false, error);

            dbContext.Set<AuditScheduleRescheduleRequest>().Add(new AuditScheduleRescheduleRequest
            {
                Id = 0,
                AuditScheduleId = id,
                ProposedStartDate = date + time,
                Reason = string.IsNullOrWhiteSpace(reason) ? null : reason.Trim(),
                Status = AuditScheduleRescheduleRequest.Statuses.PendingTeamLeader,
                RequestedByUserId = userId,
                RequestedDate = DateTime.UtcNow
            });

            return await SaveWorkflowChangesAsync(dbContext, cancellationToken);
        }

        public async Task<AuditScheduleRescheduleRequestDto?> GetLatestRescheduleRequestAsync(
            int scheduleId, string? userId, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var request = await RequestsWithSchedule(dbContext)
                .Where(r => r.AuditScheduleId == scheduleId && !r.IsDeleted)
                .OrderByDescending(r => r.Id)
                .FirstOrDefaultAsync(cancellationToken);
            if (request == null) return null;

            var dtos = await ToRequestDtosAsync(
                dbContext, new List<AuditScheduleRescheduleRequest> { request }, userId, false, cancellationToken);
            return dtos.FirstOrDefault();
        }

        public async Task<List<AuditScheduleRescheduleRequestDto>> GetPendingRescheduleRequestsAsync(
            string? userId, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(userId))
                return new List<AuditScheduleRescheduleRequestDto>();

            var dbContext = _repository.GetDbContext();

            var pending = await RequestsWithSchedule(dbContext)
                .Where(r => !r.IsDeleted &&
                    (r.Status == AuditScheduleRescheduleRequest.Statuses.PendingTeamLeader ||
                     r.Status == AuditScheduleRescheduleRequest.Statuses.PendingLeadAuditor))
                .OrderBy(r => r.RequestedDate)
                .ToListAsync(cancellationToken);

            return await ToRequestDtosAsync(dbContext, pending, userId, true, cancellationToken);
        }

        public async Task<(bool Success, string? Error)> DecideRescheduleRequestAsync(
            int requestId, string? userId, bool approve, string? remarks, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(userId))
                return (false, "Approver is required.");

            var dbContext = _repository.GetDbContext();

            var request = await RequestsWithSchedule(dbContext)
                .FirstOrDefaultAsync(r => r.Id == requestId && !r.IsDeleted, cancellationToken);
            if (request == null)
                return (false, "Reschedule request not found.");

            if (!IsPending(request.Status))
                return (false, "This reschedule request has already been decided.");

            if (!await CanDecideAsync(dbContext, userId, request, cancellationToken))
                return (false, "You are not the approver this reschedule request is waiting on.");

            var now = DateTime.UtcNow;
            var cleanRemarks = string.IsNullOrWhiteSpace(remarks) ? null : remarks.Trim();

            if (request.Status == AuditScheduleRescheduleRequest.Statuses.PendingTeamLeader)
            {
                request.TeamLeaderUserId = userId;
                request.TeamLeaderDecisionDate = now;
                request.TeamLeaderRemarks = cleanRemarks;
                // Approved -> forwarded to the Lead Auditor; rejected -> the
                // original audit schedule stays as-is.
                request.Status = approve
                    ? AuditScheduleRescheduleRequest.Statuses.PendingLeadAuditor
                    : AuditScheduleRescheduleRequest.Statuses.RejectedByTeamLeader;
            }
            else
            {
                request.LeadAuditorUserId = userId;
                request.LeadAuditorDecisionDate = now;
                request.LeadAuditorRemarks = cleanRemarks;

                if (approve)
                {
                    // Accepted: revise the schedule, the Audit Plan and (on a
                    // day change) the Audit Programme.
                    var moved = await MoveScheduleAsync(
                        request.AuditScheduleId,
                        request.ProposedStartDate.Date,
                        request.ProposedStartDate.TimeOfDay,
                        cancellationToken);
                    if (!moved.Success) return moved;

                    request.Status = AuditScheduleRescheduleRequest.Statuses.Approved;
                }
                else
                {
                    request.Status = AuditScheduleRescheduleRequest.Statuses.RejectedByLeadAuditor;
                }
            }

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
