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

        // Auto-populates a new NCAR from an Audit Report's findings whose NCAR
        // status matches ncarStatus (e.g. "NC" or "OFI"). Findings of any other
        // status are excluded.
        Task<NonconformingActionReportDto?> CreateFromAuditReportAsync(int auditReportId, string ncarStatus, string issuedByAuditorUserId, string acknowledgedByAuditeeUserId, CancellationToken cancellationToken);

        // Moves an NCAR through PENDING_VERIFICATION -> ACTIVE -> CLOSED.
        Task<(bool Success, string? Error)> ChangeStatusAsync(long id, string status, string? comments, CancellationToken cancellationToken);
    }
}
