using Base.Abstractions; // Add this or wherever IService is defined
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanApprovalModule
{
    // If you are inheriting from a base IService, ensure it is referenced:
    public interface IAuditPlanApprovalService : IService
    {
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<List<AuditPlanApprovalDto>?> GetAll(CancellationToken cancellationToken);
        Task<AuditPlanApprovalDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<DtoPageList<AuditPlanApprovalDto, AuditPlanApproval, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>;
    }
}