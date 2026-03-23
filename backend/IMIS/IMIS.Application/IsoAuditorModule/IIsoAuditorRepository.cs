using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.IsoAuditorModule
{
    public interface IIsoAuditorRepository : IRepository<IsoAuditor, int>
    {
        // --- Core Queries ---
        Task<IEnumerable<IsoAuditor>> GetAll(CancellationToken cancellationToken);

        Task<EntityPageList<IsoAuditor, int>> GetPaginatedAsync(
            int page,
            int pageSize,
            CancellationToken cancellationToken);

        Task<IsoAuditor?> GetWithDetailsAsync(int id, CancellationToken cancellationToken);

        // --- Filtered Queries ---

        /// <summary>
        /// Retrieves all auditor assignments for a specific Team.
        /// </summary>
        Task<IEnumerable<IsoAuditor>> FilterByTeamId(int teamId, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves all teams/assignments associated with a specific User.
        /// Note: Uses 'string' to match the Domain.UserId type.
        /// </summary>
        Task<IEnumerable<IsoAuditor>> FilterByUserId(string userId, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves all auditors assigned to a specific Audit Plan Entry.
        /// </summary>
        Task<IEnumerable<IsoAuditor>> FilterByAuditPlanEntryId(int entryId, CancellationToken cancellationToken);

        // --- Utility & Infrastructure ---
        Task<IsoAuditor?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}