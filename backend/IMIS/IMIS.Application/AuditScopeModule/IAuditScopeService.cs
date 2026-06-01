using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditScopeModule
{
    public interface IAuditScopeService : IService
    {
        Task<AuditScopeDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SaveAuditScopeAsync(AuditScopeDto dto, CancellationToken cancellationToken);
        Task<DtoPageList<AuditScopeDto, AuditScope, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}