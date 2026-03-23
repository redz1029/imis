using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanPersonResponsibleModule
{
    public interface IAuditPlanPersonResponsibleRepository : IRepository<AuditPlanPersonResponsible, int>
    {
        // --- Core Queries ---
        Task<IEnumerable<AuditPlanPersonResponsible>> GetAll(CancellationToken cancellationToken);

        Task<EntityPageList<AuditPlanPersonResponsible, int>> GetPaginatedAsync(
            int page,
            int pageSize,
            CancellationToken cancellationToken);

        Task<AuditPlanPersonResponsible?> GetWithDetailsAsync(int id, CancellationToken cancellationToken);

        
        Task<IEnumerable<AuditPlanPersonResponsible>> FilterByAuditPlanEntryId(int entryId, CancellationToken cancellationToken);

     
        Task<IEnumerable<AuditPlanPersonResponsible>> SearchByName(string name, CancellationToken cancellationToken);

       
        Task<AuditPlanPersonResponsible?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}