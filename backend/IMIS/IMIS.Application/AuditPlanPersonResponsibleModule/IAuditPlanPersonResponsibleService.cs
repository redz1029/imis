using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanPersonResponsibleModule
{
    public interface IAuditPlanPersonResponsibleService : IService
    {
        Task<List<AuditPlanPersonResponsibleDto>?> GetAll(CancellationToken cancellationToken);

        Task<AuditPlanPersonResponsibleDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        Task<DtoPageList<AuditPlanPersonResponsibleDto, AuditPlanPersonResponsible, int>> GetPaginatedAsync(
            int page,
            int pageSize,
            CancellationToken cancellationToken);

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}