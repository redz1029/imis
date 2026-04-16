using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleDetailsRepository : IRepository<AuditScheduleDetails, int>
    {
        /// <summary>
        /// Retrieves a paginated list of Audit Schedule Details.
        /// </summary>
        Task<EntityPageList<AuditScheduleDetails, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        /// <summary>
        /// Specialized lookup for soft delete operations using the ReadOnly context.
        /// </summary>
        Task<AuditScheduleDetails?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves all schedule details, typically used for lists where pagination isn't required.
        /// </summary>
        Task<IEnumerable<AuditScheduleDetails>> GetAll(CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves schedule details with related navigation properties (e.g., AuditSchedule, AuditPlanEntry).
        /// </summary>
        Task<AuditScheduleDetails?> GetWithDetailsAsync(int id, CancellationToken cancellationToken);

        // --- Filtered Query Definitions ---

        /// <summary>
        /// Filters details associated with a specific Audit Schedule.
        /// </summary>
        Task<IEnumerable<AuditScheduleDetails>> FilterByAuditScheduleId(int auditScheduleId, CancellationToken cancellationToken);

        /// <summary>
        /// Filters details associated with a specific Audit Plan Entry.
        /// </summary>
        Task<IEnumerable<AuditScheduleDetails>> FilterByAuditPlanEntryId(int auditPlanEntryId, CancellationToken cancellationToken);
    }
}