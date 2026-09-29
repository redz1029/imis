using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditChecklistModule
{
    public interface IAuditChecklistRepository : IRepository<AuditChecklist, int>
    {
        Task<AuditChecklist?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<AuditChecklist>> GetByAuditPlanEntryIdAsync(int auditPlanEntryId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditChecklist>> GetByAuditeeIdAsync(int auditeeId, CancellationToken cancellationToken);
        Task<IEnumerable<AuditChecklist>> GetByAuditScheduleIdAsync(int auditScheduleId, CancellationToken cancellationToken);

        Task<EntityPageList<AuditChecklist, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        Task<AuditChecklist?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<AuditChecklist>> GetByProcessIdAsync(int processId, CancellationToken cancellationToken);
        Task SaveOrUpdateAsync(CancellationToken cancellationToken);
    }
}