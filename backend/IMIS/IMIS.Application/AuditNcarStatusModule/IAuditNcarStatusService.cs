using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditNcarStatusModule
{
    public interface IAuditNcarStatusService : IService
    {
        Task<AuditNcarStatusDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SaveNcarStatusAsync(AuditNcarStatusDto dto, CancellationToken cancellationToken);
        Task<DtoPageList<AuditNcarStatusDto, AuditNcarStatus, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}