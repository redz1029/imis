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
        Task<AuditScheduleDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        // --- Save / Update ---
        Task<bool> SaveAuditScheduleAsync(AuditScheduleDto dto, CancellationToken cancellationToken);

        // --- Pagination ---
        Task<DtoPageList<AuditScheduleDto, AuditSchedule, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // --- Soft Delete ---
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        // --- Validation ---
        Task<List<string>> GetConflictValidationsAsync(AuditScheduleDto dto, CancellationToken cancellationToken);

        // --- Generic Save for parent + child collections ---
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}