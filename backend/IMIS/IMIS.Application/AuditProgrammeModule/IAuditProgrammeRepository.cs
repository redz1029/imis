using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditProgrammeModule
{
    public interface IAuditProgrammeRepository : IRepository<AuditProgramme, int>
    {
        // --- Main Retrieval ---

        /// <summary>
        /// Retrieves a basic programme by its ID, including related Objectives and Plans.
        /// </summary>
        Task<AuditProgramme?> GetByIdAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves a programme including its sorted Objectives, related Plans, 
        /// Plan Entries, and the Plan Preparer.
        /// </summary>
        Task<AuditProgramme?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves a programme specifically for soft delete operations.
        /// </summary>
        Task<AuditProgramme?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves all programmes without tracking, including Objectives and Plan Preparers.
        /// </summary>
        Task<IEnumerable<AuditProgramme>> GetAllAsync(CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves a paginated list of programmes.
        /// </summary>
        Task<EntityPageList<AuditProgramme, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // --- Child Helpers (Objectives) ---

        /// <summary>
        /// Gets a list of objective IDs currently associated with a programme.
        /// </summary>
        Task<List<int>> GetExistingObjectiveIdsAsync(int auditProgrammeId, CancellationToken cancellationToken);

        /// <summary>
        /// Bulk adds a list of objectives to the context.
        /// </summary>
        Task AddObjectivesAsync(List<AuditProgrammeObjective> objectives, CancellationToken cancellationToken);

        /// <summary>
        /// Bulk removes objectives from the context.
        /// </summary>
        void RemoveObjectives(List<AuditProgrammeObjective> objectives);
    }
}