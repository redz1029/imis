using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditChecklistQNAModule
{
    public interface IAuditChecklistQNAService : IService
    {
        Task<AuditChecklistQNADto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        Task<IEnumerable<AuditChecklistQNADto>> GetByChecklistIdAsync(int checklistId, CancellationToken cancellationToken);

        Task<bool> SaveQNAAsync(AuditChecklistQNADto dto, CancellationToken cancellationToken);

        Task<DtoPageList<AuditChecklistQNADto, AuditChecklistQNA, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        // Required for generic handling in your architecture
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}