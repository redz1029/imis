using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleService : IService
    {
        // --- Retrieval ---
        Task<List<AuditScheduleDto>?> GetAllAsync(CancellationToken cancellationToken);

        /// <summary>
        /// The schedules <paramref name="userId"/> may see. An Auditor Team Leader
        /// sees only the schedules of the team(s) they lead, a plain Auditor only
        /// those of the team(s) they belong to; every other IQA role sees all.
        /// </summary>
        Task<List<AuditScheduleDto>?> GetAllForUserAsync(string? userId, CancellationToken cancellationToken);

        /// <summary>Same visibility rule, for the schedules of one audit plan.</summary>
        Task<IEnumerable<AuditScheduleDto>> GetByAuditPlanIdForUserAsync(int auditPlanId, string? userId, CancellationToken cancellationToken);

        /// <summary>The teams the user may submit schedules for (leader flag, or the Auditor Team Leader role plus membership).</summary>
        Task<List<int>> GetLedTeamIdsAsync(string? userId, CancellationToken cancellationToken);
        Task<List<AuditScheduleDto>> GetConfirmedAsync(CancellationToken cancellationToken);
        Task<AuditScheduleDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<AuditScheduleDto>> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditScheduleDto>> GetByAuditPlanEntryIdAsync(int auditPlanEntryId, CancellationToken cancellationToken);

        // --- Save / Update ---//
        // userId: actor recorded on the workflow history/signatory rows.
        // Falls back to the JWT claim at the endpoint; null = system action.
        Task<bool> SaveAuditScheduleAsync(AuditScheduleDto dto, CancellationToken cancellationToken, string? userId = null);

        // --- Pagination ---
        Task<DtoPageList<AuditScheduleDto, AuditSchedule, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // --- Soft Delete ---
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        // --- Validation ---
        Task<List<string>> GetConflictValidationsAsync(AuditScheduleDto dto, CancellationToken cancellationToken);

        /// <summary>
        /// A schedule is submitted only by the Auditor Team Leader of the team
        /// assigned to it (Administrators excepted). Returns the reason when
        /// <paramref name="userId"/> may not, or null when it may.
        /// </summary>
        Task<string?> GetSubmitAuthorizationErrorAsync(AuditScheduleDto dto, string? userId, CancellationToken cancellationToken);

        // --- Generic Save for parent + child collections ---
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
        Task<ReportAuditScheduleDto> ReportGetByIdAsync(int id, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> DecideAsync(int id, string approverId, bool approve, string? comments, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> DecideAsync(int id, string approverId, string action, string? comments, string? officeName, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> SubmitAsync(int id, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> SubmitAsync(int id, string? userId, string? comments, CancellationToken cancellationToken);

        // Reschedule a rejected/revision-required audit schedule. Only the date
        // moves; the time stays locked to the linked audit plan entry.
        Task<(bool Success, string? Error)> RescheduleAsync(int id, DateTime proposedDate, string? comments, CancellationToken cancellationToken);

        // Department Head asks to move the schedule. Routed to the Auditor Team
        // Leader, then the Lead Auditor; the schedule is only revised once the
        // Lead Auditor accepts.
        Task<(bool Success, string? Error)> RequestRescheduleAsync(int id, DateTime proposedStart, string? reason, string? userId, CancellationToken cancellationToken);
        Task<AuditScheduleRescheduleRequestDto?> GetLatestRescheduleRequestAsync(int scheduleId, string? userId, CancellationToken cancellationToken);
        Task<List<AuditScheduleRescheduleRequestDto>> GetPendingRescheduleRequestsAsync(string? userId, CancellationToken cancellationToken);
        Task<List<AuditScheduleRescheduleRequestDto>> GetOpenRescheduleRequestsAsync(string? userId, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> DecideRescheduleRequestAsync(int requestId, string? userId, bool approve, string? remarks, CancellationToken cancellationToken);
    }
}
