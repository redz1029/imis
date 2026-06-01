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
        /// <summary>
        /// Retrieves all questions and answers associated with a specific checklist ID.
        /// </summary>
        Task<IEnumerable<AuditChecklistQNA>> GetByChecklistIdAsync(int checklistId, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves a paginated list of QNA items.
        /// </summary>
        Task<EntityPageList<AuditChecklistQNA, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}