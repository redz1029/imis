using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
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
    }
}