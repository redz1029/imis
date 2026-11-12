using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.NonconformingActionReportModule
{
    public interface INonconformingActionReportRepository : IRepository<NonconformingActionReport, long>
    {
        Task<NonconformingActionReport?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken);
        Task<EntityPageList<NonconformingActionReport, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<NonconformingActionReport?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken);
        Task<NonconformingActionReport?> GetByAuditReportIdAndTypeAsync(int auditReportId, bool isNonconformity, CancellationToken cancellationToken);

        /// <summary>
        /// The Service(s) each NCAR's audited office belongs to, by NCAR id.
        /// </summary>
        Task<Dictionary<long, List<string>>> GetServiceNamesAsync(IReadOnlyCollection<long> ncarIds, CancellationToken cancellationToken);
    }
}
