using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanProcessModule
{
    public interface IAuditPlanProcessRepository : IRepository<AuditPlanProcess, int>
    {
        Task<IEnumerable<AuditPlanProcess>> GetAll(CancellationToken cancellationToken);

        Task<EntityPageList<AuditPlanProcess, int>> GetPaginatedAsync(int page,int pageSize,CancellationToken cancellationToken);

        Task<AuditPlanProcess?> GetWithDetailsAsync(int id, CancellationToken cancellationToken);

        Task<IEnumerable<AuditPlanProcess>> FilterByOfficeId(int officeId, CancellationToken cancellationToken);

        Task<IEnumerable<AuditPlanProcess>> FilterByAuditPlanEntryId(int entryId, CancellationToken cancellationToken);

        Task<AuditPlanProcess?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}