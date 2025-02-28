using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPgsAuditDetailsRepository : IRepository<PgsAuditDetails, long>
    {
        Task<int> CountAsync(CancellationToken cancellationToken);
        Task<IEnumerable<PgsAuditDetails>> GetPagedAsync(int skip, int pageSize, CancellationToken cancellationToken);
        Task<PgsAuditDetails> SaveOrUpdateAsync(PgsAuditDetails pgsAuditDetails, CancellationToken cancellationToken);
    }
}
