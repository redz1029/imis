using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPgsAuditDetailsRepository : IRepository<PgsAuditDetails, long>
    {
        Task<IEnumerable<PgsAuditDetails>> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<PgsAuditDetails, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        new Task<PgsAuditDetails> SaveOrUpdateAsync(PgsAuditDetails pgsAuditDetails, CancellationToken cancellationToken);
    }
}
