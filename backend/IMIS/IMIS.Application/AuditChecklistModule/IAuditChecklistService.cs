using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditChecklistModule
{
    public interface IAuditChecklistService : IService
    {
        Task<AuditChecklistDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        Task<IEnumerable<AuditChecklistDto>> GetOrGenerateForAuditPlanEntryAsync(int auditPlanEntryId, CancellationToken cancellationToken);

        // userId: the signed-in user. An auditor of the team only gets the rows
        // of the clauses assigned to them; null returns every row.
        Task<IEnumerable<AuditChecklistDto>> GetOrGenerateForAuditScheduleAsync(int auditScheduleId, CancellationToken cancellationToken, string? userId = null);

        // --- Clause assignment (Auditor Team Leader -> team auditors) ---
        Task<AuditChecklistAssignmentsDto> GetAssignmentsAsync(int auditScheduleId, string? userId, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> AssignClausesAsync(int auditScheduleId, IReadOnlyList<AuditChecklistAssignmentRequestItem> assignments, string? userId, CancellationToken cancellationToken);

        // Saves one checklist row on behalf of userId. An auditor may only answer
        // (Conforming / FindingAndRemarks) rows of the clauses assigned to them.
        Task<(bool Success, string? Error)> SaveChecklistForUserAsync(AuditChecklistDto dto, string? userId, CancellationToken cancellationToken);

        // Raises the audit report of every schedule whose checklist was saved
        // before reports were automatic. Existing reports are left alone.
        Task<int> SyncMissingAuditReportsAsync(CancellationToken cancellationToken);

        // Audit Schedule is the source of truth for the checklist list —
        // returns every schedule (in schedule order) that has ISO clause /
        // team data, so the frontend never shows a hardcoded team roster.
        Task<List<AuditChecklistSummaryDto>> GetSchedulesWithChecklistDataAsync(CancellationToken cancellationToken);

        Task<IEnumerable<AuditChecklistDto>> GetByAuditeeIdAsync(int auditeeId, CancellationToken cancellationToken);

        Task<IEnumerable<AuditChecklistDto>> GetByAuditScheduleIdAsync(int auditScheduleId, CancellationToken cancellationToken);

        Task<bool> SaveChecklistAsync(AuditChecklistDto dto, CancellationToken cancellationToken);

        Task<DtoPageList<AuditChecklistDto, AuditChecklist, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
        Task<object?> GetByProcessIdAsync(int processId, CancellationToken cancellationToken);
        Task<ReportAuditChecklistDto> ReportGetByAuditScheduleIdAsync(int auditScheduleId, CancellationToken cancellationToken);
    }
}