using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditChecklistQNAModule
{
    public interface IAuditChecklistQNARepository : IRepository<AuditChecklistQNA, int>
    {
        Task<IEnumerable<AuditChecklistQNA>> GetByChecklistIdAsync(int checklistId, CancellationToken cancellationToken);

        // RENAMED from GetByChecklistIdAsync — it always filtered by
        // IsoStandardId, never by a checklist id. Update any callers.
        Task<IEnumerable<AuditChecklistQNA>> GetByIsoStandardIdAsync(long isoStandardId, CancellationToken cancellationToken);

        Task<EntityPageList<AuditChecklistQNA, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}