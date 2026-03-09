using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanEntryModule
{
    public interface IAuditPlanEntryRepository : IRepository<AuditPlanEntry, int>
    {
        // --- Core Queries ---
        Task<IEnumerable<AuditPlanEntry>> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<AuditPlanEntry, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<AuditPlanEntry?> GetWithDetailsAsync(int id, CancellationToken cancellationToken);

        // --- Filtered Queries ---
        Task<IEnumerable<AuditPlanEntry>> FilterByAuditPlanId(int auditPlanId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanEntry>> FilterByDayNumber(int auditPlanId, int dayNumber, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanEntry>> FilterByOfficeId(int officeId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanEntry>> FilterByTeamId(int teamId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanEntry>> FilterByProcessId(int processId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanEntry>> FilterByAuditorId(string auditorId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanEntry>> FilterByResponsiblePersonId(int personId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanEntry>> FilterByIsoStandardId(int standardId, CancellationToken cancellationToken);

        // --- Utility & Infrastructure ---
        Task<AuditPlanEntry?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}