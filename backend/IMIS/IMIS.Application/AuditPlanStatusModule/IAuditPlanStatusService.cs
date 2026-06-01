using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanStatusModule
{
    public interface IAuditPlanStatusService : IService
    {
        Task<List<AuditPlanStatusDTO>?> GetAllAsync(CancellationToken cancellationToken);

        Task<DtoPageList<AuditPlanStatusDTO, AuditPlanStatus, int>> GetPaginatedAsync(
            int page,
            int pageSize,
            CancellationToken cancellationToken);
    }
}