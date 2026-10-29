using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditReportModule;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.NonconformingActionReportModule
{
    public class NonconformingActionReportService : INonconformingActionReportService
    {
        private readonly INonconformingActionReportRepository _repository;
        private readonly IAuditReportRepository _auditReportRepository;

        public NonconformingActionReportService(INonconformingActionReportRepository repository, IAuditReportRepository auditReportRepository)
        {
            _repository = repository;
            _auditReportRepository = auditReportRepository;
        }

        public async Task<NonconformingActionReportDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new NonconformingActionReportDto(entity);
        }

        public async Task<bool> SaveNcarAsync(NonconformingActionReportDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) return false;
            await SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not NonconformingActionReportDto nDto)
                throw new InvalidOperationException("Invalid DTO type.");

            var entity = nDto.ToEntity();
            var dbContext = _repository.GetDbContext();

            if (entity.Id == 0)
            {
                dbContext.Add(entity);
            }
            else
            {
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken).ConfigureAwait(false);
                if (existing != null)
                {
                    // The checklist link is owned by the server (AuditChecklistService):
                    // ToEntity() never carries it, so an update must not wipe it.
                    var auditChecklistId = existing.AuditChecklistId;

                    if (existing.RootCauses?.Any() == true)
                        dbContext.Set<NcarRootCause>().RemoveRange(existing.RootCauses);

                    if (existing.Corrections?.Any() == true)
                        dbContext.Set<NcarCorrectionAction>().RemoveRange(existing.Corrections);

                    if (existing.CorrectiveActions?.Any() == true)
                        dbContext.Set<NcarCorrectiveAction>().RemoveRange(existing.CorrectiveActions);

                    dbContext.Entry(existing).CurrentValues.SetValues(entity);
                    existing.AuditChecklistId = auditChecklistId;

                    foreach (var rootCause in entity.RootCauses)
                        dbContext.Set<NcarRootCause>().Add(rootCause);

                    foreach (var correction in entity.Corrections)
                        dbContext.Set<NcarCorrectionAction>().Add(correction);

                    foreach (var correctiveAction in entity.CorrectiveActions)
                        dbContext.Set<NcarCorrectiveAction>().Add(correctiveAction);
                }
            }

            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            nDto.Id = entity.Id;
        }

        public async Task<DtoPageList<NonconformingActionReportDto, NonconformingActionReport, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (result.TotalCount == 0) return null!;

            return DtoPageList<NonconformingActionReportDto, NonconformingActionReport, long>.Create(
                result.Items,
                page,
                pageSize,
                result.TotalCount);
        }

        public async Task<bool> SoftDeleteAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return false;

            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task<NonconformingActionReportDto?> CreateFromAuditReportAsync(int auditReportId, string ncarStatus, string issuedByAuditorUserId, string acknowledgedByAuditeeUserId, CancellationToken cancellationToken)
        {
            // The caller chooses which finding status this NCAR is raised for
            // ("NC" or "OFI"). Only findings whose status matches are included;
            // everything else (including findings left with no status) is skipped.
            // If no finding matches, there is nothing to report and no NCAR is created.
            var statusFilter = ncarStatus?.Trim();
            if (string.IsNullOrEmpty(statusFilter)) return null;

            var isNonconformity = string.Equals(statusFilter, "NC", StringComparison.OrdinalIgnoreCase);

            // NC and OFI are treated as separate NCARs for the same report, so the
            // duplicate guard is scoped to the requested type: an existing NCAR is
            // only reused when it is the same kind (IsNonconformity) as the request.
            var existingNcar = await _repository.GetByAuditReportIdAndTypeAsync(auditReportId, isNonconformity, cancellationToken).ConfigureAwait(false);
            if (existingNcar != null)
                return new NonconformingActionReportDto(existingNcar);

            var auditReport = await _auditReportRepository.GetByIdWithDetailsAsync(auditReportId, cancellationToken).ConfigureAwait(false);
            if (auditReport == null) return null;

            var matchedFindings = auditReport.AuditSummaryFIndings?
                .Where(f => string.Equals(f.NcarStatus?.ncarStatus?.Trim(), statusFilter, StringComparison.OrdinalIgnoreCase))
                .ToList() ?? new List<AuditSummaryFIndings>();

            if (matchedFindings.Count == 0) return null;

            var findingsText = string.Join(Environment.NewLine, matchedFindings.Select(f => f.Findings));

            var standardRef = auditReport.AuditStandardISO?.ClauseRef ?? string.Empty;
            var officeName = auditReport.OfficeAudited?.Office?.Name ?? auditReport.OfficeAudited?.ProcessName ?? string.Empty;

            // Prefix by type so the NCAR and OFI raised from the same report get
            // distinct reference numbers.
            var referencePrefix = isNonconformity ? "NCAR" : "OFI";
            var referenceNumber = $"{referencePrefix}-{DateTime.UtcNow:yyyy}-{auditReport.Id:D4}";

            var entity = new NonconformingActionReport
            {
                Id = 0,
                ReferenceNumber = referenceNumber,
                Office = officeName,
                RelevantStandard = standardRef,
                AuditDate = auditReport.AuditPlanEntry?.Time ?? DateTime.UtcNow,

                IsInternalAudit = true,
                IsNonconformity = isNonconformity,

                StandardRequirement = standardRef,
                LegalOrPolicyReference = string.Empty,
                AuditFindings = findingsText ?? string.Empty,

                AuditReportId = auditReport.Id,

                IssuedByAuditorUserId = issuedByAuditorUserId,
                IssuedDate = DateTime.UtcNow,

                AcknowledgedByAuditeeUserId = acknowledgedByAuditeeUserId,

                IsActive = true,
                IsClosed = false
            };

            var dbContext = _repository.GetDbContext();
            dbContext.Add(entity);
            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return new NonconformingActionReportDto(entity);
        }

        public async Task<List<NcarAttachmentDto>> GetAttachmentsAsync(long ncarId, CancellationToken cancellationToken)
        {
            var rows = await _repository.GetDbContext().Set<NcarAttachment>()
                .AsNoTracking()
                .Where(a => a.NonconformingActionReportId == ncarId)
                .OrderBy(a => a.OrderNumber).ThenBy(a => a.Id)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            return rows.Select(a => new NcarAttachmentDto(a)).ToList();
        }

        public async Task<(NcarAttachmentDto? Attachment, string? Error)> AddAttachmentAsync(long ncarId, string fileName, byte[] content, string? caption, CancellationToken cancellationToken)
        {
            if (content == null || content.Length == 0)
                return (null, "The picture is empty.");

            if (content.Length > NcarAttachmentRules.MaxBytes)
                return (null, $"The picture is larger than {NcarAttachmentRules.MaxBytes / (1024 * 1024)} MB.");

            var contentType = NcarAttachmentRules.DetectImageType(content);
            if (contentType == null)
                return (null, "Only PNG or JPEG pictures can be attached.");

            var dbContext = _repository.GetDbContext();

            var ncarExists = await dbContext.Set<NonconformingActionReport>()
                .AnyAsync(n => n.Id == ncarId, cancellationToken)
                .ConfigureAwait(false);
            if (!ncarExists)
                return (null, "Nonconforming action report not found.");

            var existing = await dbContext.Set<NcarAttachment>()
                .Where(a => a.NonconformingActionReportId == ncarId)
                .Select(a => a.OrderNumber)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
            if (existing.Count >= NcarAttachmentRules.MaxPerNcar)
                return (null, $"An NCAR can hold at most {NcarAttachmentRules.MaxPerNcar} pictures.");

            var safeName = string.IsNullOrWhiteSpace(fileName) ? "picture" : System.IO.Path.GetFileName(fileName.Trim());

            var entity = new NcarAttachment
            {
                Id = 0,
                NonconformingActionReportId = ncarId,
                FileName = safeName,
                ContentType = contentType,
                Content = content,
                Caption = string.IsNullOrWhiteSpace(caption) ? null : caption.Trim(),
                OrderNumber = existing.Count == 0 ? 1 : existing.Max() + 1
            };

            dbContext.Add(entity);
            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return (new NcarAttachmentDto(entity), null);
        }

        public async Task<bool> DeleteAttachmentAsync(long ncarId, long attachmentId, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();
            var entity = await dbContext.Set<NcarAttachment>()
                .FirstOrDefaultAsync(a => a.Id == attachmentId && a.NonconformingActionReportId == ncarId, cancellationToken)
                .ConfigureAwait(false);
            if (entity == null) return false;

            entity.IsDeleted = true;
            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task<(bool Success, string? Error)> ChangeStatusAsync(long id, string status, string? comments, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return (false, "Nonconforming action report not found.");

            var target = status?.Trim();
            if (string.IsNullOrEmpty(target)) return (false, "Status is required.");

            var current = entity.IsClosed
                ? NonconformingActionReportWorkflowPermission.StatusClosed
                : entity.IsActive
                    ? NonconformingActionReportWorkflowPermission.StatusActive
                    : NonconformingActionReportWorkflowPermission.StatusPendingVerification;

            bool valid = (current, target.ToUpperInvariant()) switch
            {
                (NonconformingActionReportWorkflowPermission.StatusPendingVerification, NonconformingActionReportWorkflowPermission.StatusActive) => true,
                (NonconformingActionReportWorkflowPermission.StatusActive, NonconformingActionReportWorkflowPermission.StatusClosed) => true,
                _ => false
            };

            if (!valid)
                return (false, $"Cannot change NCAR status from {current} to {target}.");

            entity.IsActive = !string.Equals(target, NonconformingActionReportWorkflowPermission.StatusClosed, StringComparison.OrdinalIgnoreCase);
            entity.IsClosed = string.Equals(target, NonconformingActionReportWorkflowPermission.StatusClosed, StringComparison.OrdinalIgnoreCase);

            if (entity.IsClosed)
            {
                entity.ValidatedDate = DateTime.UtcNow;
                if (!string.IsNullOrWhiteSpace(comments))
                    entity.VerificationDetails = comments;
            }

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return (true, null);
        }
    }
}
