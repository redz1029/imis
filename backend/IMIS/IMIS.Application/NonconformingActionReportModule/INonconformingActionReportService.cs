using System.Collections.Generic;
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

        // The NCAR form, step by step. Each step belongs to one side and is only
        // open while the form is at the right point; on success the saved NCAR is
        // returned, otherwise the reason it was refused.
        //   auditor : issuance -> verification -> validate and close
        //   auditee : acknowledge -> response -> (department head) approval
        Task<(NonconformingActionReportDto? Ncar, string? Error)> UpdateIssuanceAsync(long id, NcarIssuanceRequest request, CancellationToken cancellationToken);
        Task<(NonconformingActionReportDto? Ncar, string? Error)> AcknowledgeAsync(long id, string userId, CancellationToken cancellationToken);
        Task<(NonconformingActionReportDto? Ncar, string? Error)> SaveResponseAsync(long id, NcarResponseRequest request, string userId, CancellationToken cancellationToken);
        Task<(NonconformingActionReportDto? Ncar, string? Error)> ApproveAsync(long id, string userId, CancellationToken cancellationToken);
        Task<(NonconformingActionReportDto? Ncar, string? Error)> SaveVerificationAsync(long id, NcarVerificationRequest request, string userId, CancellationToken cancellationToken);
        Task<(NonconformingActionReportDto? Ncar, string? Error)> ValidateAndCloseAsync(long id, string userId, CancellationToken cancellationToken);

        // Pictures attached as proof the nonconformity was resolved (page 2 of the form).
        Task<List<NcarAttachmentDto>> GetAttachmentsAsync(long ncarId, CancellationToken cancellationToken);
        Task<(NcarAttachmentDto? Attachment, string? Error)> AddAttachmentAsync(long ncarId, string fileName, byte[] content, string? caption, CancellationToken cancellationToken);
        Task<bool> DeleteAttachmentAsync(long ncarId, long attachmentId, CancellationToken cancellationToken);
    }
}
