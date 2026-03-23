using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.IsoStandardAuditPlanModule
{
    public interface IIsoStandardAuditPlanRepository : IRepository<IsoStandardAuditPlan, int>
    {
       
        Task<IEnumerable<IsoStandardAuditPlan>> GetAll(CancellationToken cancellationToken);

        Task<EntityPageList<IsoStandardAuditPlan, int>> GetPaginatedAsync( int page,int pageSize,CancellationToken cancellationToken);

        Task<IsoStandardAuditPlan?> GetWithDetailsAsync(int id, CancellationToken cancellationToken);


        Task<IEnumerable<IsoStandardAuditPlan>> FilterByAuditPlanEntryId(int auditPlanEntryId, CancellationToken cancellationToken);

        Task<IEnumerable<IsoStandardAuditPlan>> FilterByIsoStandardId(int isoStandardId, CancellationToken cancellationToken);

        Task<IsoStandardAuditPlan?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}