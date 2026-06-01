using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditProgrammeModule
{
    public interface IAuditProgrammeService : IService
    {
        // --- Retrieval ---
        /// <summary>
        /// Retrieves all audit programmes, typically ordered by SortOrder if applicable.
        /// </summary>
        Task<List<AuditProgrammeDto>?> GetAllAsync(CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves a specific audit programme by ID, including its related Objectives.
        /// </summary>
        Task<AuditProgrammeDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        // --- Save / Update ---
        /// <summary>
        /// Specialized save for AuditProgramme to handle child objective collections.
        /// </summary>
        Task<bool> SaveAuditProgrammeAsync(AuditProgrammeDto dto, CancellationToken cancellationToken);

        // --- Pagination ---
        /// <summary>
        /// Retrieves a paginated list of audit programmes mapped to DTOs.
        /// </summary>
        Task<DtoPageList<AuditProgrammeDto, AuditProgramme, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // --- Soft Delete ---
        /// <summary>
        /// Performs a soft delete on the programme.
        /// </summary>
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        // --- Validation ---
        /// <summary>
        /// Validates if there are any logical conflicts or missing requirements for the programme.
        /// </summary>
        Task<List<string>> GetConflictValidationsAsync(AuditProgrammeDto dto, CancellationToken cancellationToken);

        // --- Generic Save ---
        /// <summary>
        /// Shared persistence logic using the BaseDto pattern.
        /// </summary>
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}