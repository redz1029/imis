using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.IsoAuditProcessModule
{
    public interface IIsoAuditProcessRepository : IRepository<IsoAuditProcess, int>
    {
        Task<IEnumerable<IsoAuditProcess>> GetAll(CancellationToken cancellationToken);

        Task<EntityPageList<IsoAuditProcess, int>> GetPaginatedAsync( int page, int pageSize,CancellationToken cancellationToken);

        Task<IsoAuditProcess?> GetWithDetailsAsync(int id, CancellationToken cancellationToken);

       
        Task<IEnumerable<IsoAuditProcess>> FilterByAuditPlanEntryId(int auditPlanEntryId, CancellationToken cancellationToken);

  
        Task<IEnumerable<IsoAuditProcess>> FilterByStatus(bool isActive, CancellationToken cancellationToken);

        Task<IsoAuditProcess?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}