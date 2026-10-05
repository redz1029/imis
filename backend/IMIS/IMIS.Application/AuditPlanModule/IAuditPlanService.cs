using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditPlanModule
{
    public interface IAuditPlanService : IService
    {
        // --- Retrieval ---
        Task<List<AuditPlanDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<List<AuditPlanDto>> GetApprovedAsync(CancellationToken cancellationToken);
        Task<AuditPlanDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        // --- Save / Update ---
        Task<bool> SaveAuditPlanAsync(AuditPlanDto dto, CancellationToken cancellationToken);

        // --- Pagination ---
        Task<DtoPageList<AuditPlanDto, AuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // --- Soft Delete ---
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        // --- Validation ---
        Task<List<string>> GetConflictValidationsAsync(AuditPlanDto dto, CancellationToken cancellationToken);

        // --- Generic Save for parent + child collections ---
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
        Task<AuditPlanDto?> GetByProgrammeIdAsync(int programmeId, CancellationToken cancellationToken);

        Task<ReportAuditPlanDto?> ReportGetByIdAsync(int id, CancellationToken cancellationToken);

        Task<(bool Success, string? Error)> SubmitAsync(int id, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> SubmitAsync(int id, string? userId, string? comments, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> DecideAsync(int id, string approverId, bool approve, string? comments, CancellationToken cancellationToken);
        Task<(bool Success, string? Error)> DecideAsync(int id, string approverId, string action, string? comments, CancellationToken cancellationToken);
    }
}