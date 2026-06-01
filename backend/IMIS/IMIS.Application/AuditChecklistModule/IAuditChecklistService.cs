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
        // --- Retrieval ---

        /// <summary>
        /// Retrieves a specific checklist by ID with its full details (Auditor, Process, etc).
        /// </summary>
        Task<AuditChecklistDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves all checklists associated with a specific Audit Plan Process.
        /// </summary>
        Task<IEnumerable<AuditChecklistDto>> GetByProcessIdAsync(int processId, CancellationToken cancellationToken);

        // --- Save / Update ---

        /// <summary>
        /// Handles the saving or updating of a checklist, including business rule validation.
        /// </summary>
        Task<bool> SaveChecklistAsync(AuditChecklistDto dto, CancellationToken cancellationToken);

        // --- Pagination ---

        /// <summary>
        /// Retrieves a paginated list of checklists mapped to DTOs.
        /// </summary>
        Task<DtoPageList<AuditChecklistDto, AuditChecklist, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // --- Soft Delete ---

        /// <summary>
        /// Performs a soft delete on the checklist.
        /// </summary>
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        // --- Generic Persistence ---

        /// <summary>
        /// Shared persistence logic using the BaseDto pattern.
        /// </summary>
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}