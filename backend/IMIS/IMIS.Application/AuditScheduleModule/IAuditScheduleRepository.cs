using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleRepository : IRepository<AuditSchedule, int>
    {
        // Main retrieval
        Task<AuditSchedule?> GetByIdAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves the schedule including AuditorTeams, AuditableOffices, and AuditScheduleDetails.
        /// </summary>
        Task<AuditSchedule?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);

        Task<AuditSchedule?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);

        Task<IEnumerable<AuditSchedule>> GetAllAsync(CancellationToken cancellationToken);

        Task<EntityPageList<AuditSchedule, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // Child helpers for managing many-to-many or one-to-many relationships
        Task<List<int>> GetExistingAuditableOfficeIdsAsync(int auditScheduleId, CancellationToken cancellationToken);
        Task<List<int>> GetExistingAuditScheduleDetailsIdsAsync(int auditScheduleId, CancellationToken cancellationToken);

        Task AddAuditableOfficesAsync(List<AuditableOffices> offices, CancellationToken cancellationToken);
        Task AddAuditScheduleDetailsAsync(List<AuditScheduleDetails> details, CancellationToken cancellationToken);
    }
}