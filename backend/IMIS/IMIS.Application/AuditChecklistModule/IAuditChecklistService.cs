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

        Task<IEnumerable<AuditChecklistDto>> GetOrGenerateForAuditPlanEntryAsync(int auditPlanEntryId, CancellationToken cancellationToken);

        Task<IEnumerable<AuditChecklistDto>> GetByAuditeeIdAsync(int auditeeId, CancellationToken cancellationToken);

        Task<bool> SaveChecklistAsync(AuditChecklistDto dto, CancellationToken cancellationToken);

        Task<DtoPageList<AuditChecklistDto, AuditChecklist, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
        Task<object?> GetByProcessIdAsync(int processId, CancellationToken cancellationToken);
    }
}