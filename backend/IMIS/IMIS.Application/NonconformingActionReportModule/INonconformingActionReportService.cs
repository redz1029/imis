using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.NonconformingActionReportModule
{
    public interface INonconformingActionReportService : IService
    {
        Task<NonconformingActionReportDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<bool> SaveNcarAsync(NonconformingActionReportDto dto, CancellationToken cancellationToken);
        Task<DtoPageList<NonconformingActionReportDto, NonconformingActionReport, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(long id, CancellationToken cancellationToken);

        // Auto-populates a new NCAR from an Audit Report's findings.
        Task<NonconformingActionReportDto?> CreateFromAuditReportAsync(int auditReportId, string issuedByAuditorUserId, string acknowledgedByAuditeeUserId, CancellationToken cancellationToken);
    }
}
