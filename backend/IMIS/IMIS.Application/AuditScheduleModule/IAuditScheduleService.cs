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
        Task<List<AuditScheduleDto>> GetConfirmedAsync(CancellationToken cancellationToken);
        Task<AuditScheduleDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<AuditScheduleDto>> GetByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditScheduleDto>> GetByAuditPlanEntryIdAsync(int auditPlanEntryId, CancellationToken cancellationToken);

        // --- Save / Update ---
        // userId: actor recorded on the workflow history/signatory rows.
        // Falls back to the JWT claim at the endpoint; null = system action.
        Task<bool> SaveAuditScheduleAsync(AuditScheduleDto dto, CancellationToken cancellationToken, string? userId = null);

        // --- Pagination ---
        Task<DtoPageList<AuditScheduleDto, AuditSchedule, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // --- Soft Delete ---
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        // --- Validation ---
        Task<List<string>> GetConflictValidationsAsync(AuditScheduleDto dto, CancellationToken cancellationToken);

        // --- Generic Save for parent + child collections ---
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
        Task<ReportAuditScheduleDto> ReportGetByIdAsync(int id, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> DecideAsync(int id, string approverId, bool approve, string? comments, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> DecideAsync(int id, string approverId, string action, string? comments, string? officeName, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> SubmitAsync(int id, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> SubmitAsync(int id, string? userId, string? comments, CancellationToken cancellationToken);
    }
}
