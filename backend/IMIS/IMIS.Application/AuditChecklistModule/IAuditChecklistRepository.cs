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
        /// <summary>
        /// Retrieves an audit checklist by ID including navigation properties: 
        /// Auditor, QnA, and AuditChecklistQNA.
        /// </summary>
        Task<AuditChecklist?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves all checklists associated with a specific Audit Checklist QNA record.
        /// This replaces the old 'ProcessId' logic to match your new Domain structure.
        /// </summary>
        Task<IEnumerable<AuditChecklist>> GetByQnAIdAsync(int qnaId, CancellationToken cancellationToken);

        /// <summary>
        /// Retrieves a paginated list of audit checklists including related data.
        /// </summary>
        Task<EntityPageList<AuditChecklist, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        /// <summary>
        /// Specifically for soft delete operations to ensure the entity is tracked by the context.
        /// </summary>
        Task<AuditChecklist?> GetByIdForDeleteAsync(int id, CancellationToken cancellationToken);
    }
}