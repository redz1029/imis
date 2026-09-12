using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditChecklistModule
{
    public interface IAuditChecklistService : IService
    {
        Task<AuditChecklistDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        /// <summary>
        /// Returns this entry's checklist, generating one row per applicable
        /// library question (matching the entry's selected ISO standards) the
        /// first time it's requested. Subsequent calls just return the
        /// existing rows.
        /// </summary>
        Task<IEnumerable<AuditChecklistDto>> GetOrGenerateForAuditPlanEntryAsync(int auditPlanEntryId, CancellationToken cancellationToken);

        Task<bool> SaveChecklistAsync(AuditChecklistDto dto, CancellationToken cancellationToken);

        Task<DtoPageList<AuditChecklistDto, AuditChecklist, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
        Task<object?> GetByProcessIdAsync(int processId, CancellationToken cancellationToken);

    }
}