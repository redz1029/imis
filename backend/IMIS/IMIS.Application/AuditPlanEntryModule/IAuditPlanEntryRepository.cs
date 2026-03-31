using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditPlanEntryModule
{
    public interface IAuditPlanEntryRepository : IRepository<AuditPlanEntry, int>
    {
        // Main entity retrieval
        Task<AuditPlanEntry?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<AuditPlanEntry?> GetByAuditPlanEntryIdAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanEntry>> GetAllAsync(CancellationToken cancellationToken);
        Task<IEnumerable<AuditPlanEntry>> GetAllByAuditPlanIdAsync(int auditPlanId, CancellationToken cancellationToken);
        Task<EntityPageList<AuditPlanEntry, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        // Child collection helpers
        Task<List<int>> GetExistingIsoAuditProcessIdsAsync(int auditPlanEntryId, CancellationToken cancellationToken);
        Task AddIsoAuditProcessesAsync(List<IsoAuditProcess> processes, CancellationToken cancellationToken);

        Task<List<int>> GetExistingResponsiblePersonIdsAsync(int auditPlanEntryId, CancellationToken cancellationToken);
        Task AddResponsiblePersonsAsync(List<AuditPlanPersonResponsible> persons, CancellationToken cancellationToken);

        Task<List<int>> GetExistingIsoAuditorIdsAsync(int auditPlanEntryId, CancellationToken cancellationToken);
        Task AddIsoAuditorsAsync(List<IsoAuditor> auditors, CancellationToken cancellationToken);

        Task<List<long>> GetExistingIsoStandardAuditPlanIdsAsync(int auditPlanEntryId, CancellationToken cancellationToken);
        Task AddIsoStandardAuditPlansAsync(List<IsoStandardAuditPlan> standards, CancellationToken cancellationToken);

        Task<List<int>> GetExistingAuditPlanProcessIdsAsync(int auditPlanEntryId, CancellationToken cancellationToken);
        Task AddAuditPlanProcessesAsync(List<AuditPlanProcess> processes, CancellationToken cancellationToken);

        // Optional: generic collection save
        Task AddAuditPlanEntryCollectionsAsync(AuditPlanEntry entity, CancellationToken cancellationToken);
    }
}