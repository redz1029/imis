using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditeeModule
{
    public interface IAuditeeService : IService
    {
        Task<List<AuditeeDto>?> GetAll(CancellationToken cancellationToken);

        Task<AuditeeDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        Task<DtoPageList<AuditeeDto, Auditee, int>> GetPaginatedAsync(
            int page,
            int pageSize,
            CancellationToken cancellationToken);

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}