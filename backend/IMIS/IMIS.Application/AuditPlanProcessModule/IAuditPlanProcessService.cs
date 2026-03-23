using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanProcessModule
{
    public interface IAuditPlanProcessService : IService
    {
        Task<List<AuditPlanProcessDto>?> GetAll(CancellationToken cancellationToken);

        Task<AuditPlanProcessDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        Task<DtoPageList<AuditPlanProcessDto, AuditPlanProcess, int>> GetPaginatedAsync(
            int page,
            int pageSize,
            CancellationToken cancellationToken);

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);

        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;
    }
}