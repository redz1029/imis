using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditReportModule;
using IMIS.Application.IqaNotificationModule;
using IMIS.Application.NcarMonitoringLogModule;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.NonconformingActionReportModule
{
    public class NonconformingActionReportService : INonconformingActionReportService
    {
        private readonly INonconformingActionReportRepository _repository;
        private readonly IAuditReportRepository _auditReportRepository;
        private readonly INcarMonitoringLogService _monitoringLogService;

        public NonconformingActionReportService(
            INonconformingActionReportRepository repository,
            IAuditReportRepository auditReportRepository,
            INcarMonitoringLogService monitoringLogService)
        {
            _repository = repository;
            _auditReportRepository = auditReportRepository;
            _monitoringLogService = monitoringLogService;
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
                    var findingEdited = existing.FindingEditedByAuditor;

                    if (existing.RootCauses?.Any() == true)
                        dbContext.Set<NcarRootCause>().RemoveRange(existing.RootCauses);

                    if (existing.Corrections?.Any() == true)
                        dbContext.Set<NcarCorrectionAction>().RemoveRange(existing.Corrections);

                    if (existing.CorrectiveActions?.Any() == true)
                        dbContext.Set<NcarCorrectiveAction>().RemoveRange(existing.CorrectiveActions);

                    dbContext.Entry(existing).CurrentValues.SetValues(entity);
                    existing.AuditChecklistId = auditChecklistId;
                    existing.FindingEditedByAuditor = findingEdited;

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

        // =====================================================================
        // The NCAR form, step by step
        //
        // The form is written by two sides. The auditor writes the finding
        // (issuance), later verifies the actions and the lead auditor validates
        // and closes. The auditee acknowledges, writes the root causes and the
        // proposed actions, and the department head approves them. Each step is
        // only open at the right point of the form, so neither side can change
        // what the other one signed.
        // =====================================================================

        private const string NotFound = "Nonconforming action report not found.";

        private static string? ClosedError(NonconformingActionReport n) =>
            n.IsClosed ? $"NCAR {n.ReferenceNumber} is already closed." : null;

        private async Task<(NonconformingActionReportDto? Ncar, string? Error)> Saved(long id, CancellationToken cancellationToken)
        {
            var dto = await GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return dto == null ? (null, NotFound) : (dto, null);
        }

        private static List<string> Clean(IEnumerable<string>? items) =>
            (items ?? Enumerable.Empty<string>())
                .Select(i => (i ?? string.Empty).Trim())
                .Where(i => i.Length > 0)
                .ToList();

        public async Task<(NonconformingActionReportDto? Ncar, string? Error)> UpdateIssuanceAsync(
            long id, NcarIssuanceRequest request, CancellationToken cancellationToken)
        {
            if (request == null) return (null, "Nothing to save.");

            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return (null, NotFound);
            var closed = ClosedError(entity);
            if (closed != null) return (null, closed);

            var standard = (request.RelevantStandard ?? string.Empty).Trim();
            var requirement = (request.StandardRequirement ?? string.Empty).Trim();
            var findings = (request.AuditFindings ?? string.Empty).Trim();
            if (standard.Length == 0) return (null, "The relevant standard is required.");
            if (requirement.Length == 0) return (null, "The standard requirement is required.");
            if (findings.Length == 0) return (null, "The audit finding is required.");

            // A finding rewritten here is the auditor's: the checklist stops replacing it.
            if (!string.Equals(entity.AuditFindings, findings, StringComparison.Ordinal))
                entity.FindingEditedByAuditor = true;

            entity.RelevantStandard = standard;
            entity.StandardRequirement = requirement;
            entity.LegalOrPolicyReference = (request.LegalOrPolicyReference ?? string.Empty).Trim();
            entity.AuditFindings = findings;

            entity.IsInternalAudit = request.IsInternalAudit;
            entity.IsExternalAudit = request.IsExternalAudit;
            entity.IsNonconformity = request.IsNonconformity;
            entity.IsInternalCustomer = request.IsInternalCustomer;
            entity.IsExternalCustomer = request.IsExternalCustomer;
            entity.IsComplaint = request.IsComplaint;
            entity.IsResponseRate = request.IsResponseRate;
            entity.IsOperations = request.IsOperations;

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return await Saved(id, cancellationToken).ConfigureAwait(false);
        }

        public async Task<(NonconformingActionReportDto? Ncar, string? Error)> AcknowledgeAsync(
            long id, string userId, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(userId)) return (null, "Unable to identify the signed-in user.");

            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return (null, NotFound);
            var closed = ClosedError(entity);
            if (closed != null) return (null, closed);
            if (entity.AcknowledgedDate != null)
                return (null, $"NCAR {entity.ReferenceNumber} was already acknowledged.");

            entity.AcknowledgedByAuditeeUserId = userId;
            entity.AcknowledgedDate = DateTime.UtcNow;

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            await NotifyAsync(entity, userId, IqaNotifier.Types.NcarAcknowledged,
                "NCAR acknowledged",
                "{who} acknowledged NCAR {ref}. The office will now write its response.",
                new[] { entity.IssuedByAuditorUserId }, cancellationToken).ConfigureAwait(false);
            return await Saved(id, cancellationToken).ConfigureAwait(false);
        }

        public async Task<(NonconformingActionReportDto? Ncar, string? Error)> SaveResponseAsync(
            long id, NcarResponseRequest request, string userId, CancellationToken cancellationToken)
        {
            if (request == null) return (null, "Nothing to save.");
            if (string.IsNullOrWhiteSpace(userId)) return (null, "Unable to identify the signed-in user.");

            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return (null, NotFound);
            var closed = ClosedError(entity);
            if (closed != null) return (null, closed);
            if (entity.AcknowledgedDate == null)
                return (null, "Acknowledge the NCAR before answering it.");
            if (entity.ApprovedDate != null)
                return (null, "The proposed actions were already approved, so the response can no longer be changed.");

            var rootCauses = Clean(request.RootCauses);
            var corrections = Clean(request.Corrections);
            var correctives = Clean(request.CorrectiveActions);
            if (rootCauses.Count == 0) return (null, "Write at least one root cause.");
            if (corrections.Count == 0 && correctives.Count == 0)
                return (null, "Write at least one correction or corrective action.");

            var dbContext = _repository.GetDbContext();

            dbContext.Set<NcarRootCause>().RemoveRange(
                await dbContext.Set<NcarRootCause>().Where(x => x.NonconformingActionReportId == id).ToListAsync(cancellationToken).ConfigureAwait(false));
            dbContext.Set<NcarCorrectionAction>().RemoveRange(
                await dbContext.Set<NcarCorrectionAction>().Where(x => x.NonconformingActionReportId == id).ToListAsync(cancellationToken).ConfigureAwait(false));
            dbContext.Set<NcarCorrectiveAction>().RemoveRange(
                await dbContext.Set<NcarCorrectiveAction>().Where(x => x.NonconformingActionReportId == id).ToListAsync(cancellationToken).ConfigureAwait(false));

            for (var i = 0; i < rootCauses.Count; i++)
                dbContext.Set<NcarRootCause>().Add(new NcarRootCause { Id = 0, NonconformingActionReportId = id, CauseDescription = rootCauses[i], OrderNumber = i + 1 });
            for (var i = 0; i < corrections.Count; i++)
                dbContext.Set<NcarCorrectionAction>().Add(new NcarCorrectionAction { Id = 0, NonconformingActionReportId = id, ActionDescription = corrections[i], OrderNumber = i + 1 });
            for (var i = 0; i < correctives.Count; i++)
                dbContext.Set<NcarCorrectiveAction>().Add(new NcarCorrectiveAction { Id = 0, NonconformingActionReportId = id, ActionDescription = correctives[i], OrderNumber = i + 1 });

            entity.ProposedByAuditeeUserId = userId;
            entity.ProposedDate = DateTime.UtcNow;

            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            var heads = await IqaNotifier.OfficeHeadsByNameAsync(dbContext, entity.Office, cancellationToken).ConfigureAwait(false);
            await NotifyAsync(entity, userId, IqaNotifier.Types.NcarResponded,
                "NCAR response waiting for your approval",
                "{who} wrote the root causes and proposed actions for NCAR {ref}. Please approve them.",
                heads, cancellationToken).ConfigureAwait(false);
            return await Saved(id, cancellationToken).ConfigureAwait(false);
        }

        public async Task<(NonconformingActionReportDto? Ncar, string? Error)> ApproveAsync(
            long id, string userId, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(userId)) return (null, "Unable to identify the signed-in user.");

            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return (null, NotFound);
            var closed = ClosedError(entity);
            if (closed != null) return (null, closed);
            if (entity.ProposedDate == null)
                return (null, "The office has not written its response yet, so there is nothing to approve.");
            if (entity.ApprovedDate != null)
                return (null, $"NCAR {entity.ReferenceNumber} was already approved.");

            entity.ApprovedByHeadUserId = userId;
            entity.ApprovedDate = DateTime.UtcNow;

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            // The approved NCAR goes on the monitoring log (QP-03-F-09).
            await SyncMonitoringLogAsync(id, cancellationToken).ConfigureAwait(false);

            await NotifyAsync(entity, userId, IqaNotifier.Types.NcarApproved,
                "NCAR actions approved - ready to verify",
                "{who} approved the proposed actions of NCAR {ref}. Verify that they were carried out.",
                new[] { entity.IssuedByAuditorUserId, entity.ProposedByAuditeeUserId }, cancellationToken).ConfigureAwait(false);
            return await Saved(id, cancellationToken).ConfigureAwait(false);
        }

        public async Task<(NonconformingActionReportDto? Ncar, string? Error)> SaveVerificationAsync(
            long id, NcarVerificationRequest request, string userId, CancellationToken cancellationToken)
        {
            if (request == null) return (null, "Nothing to save.");
            if (string.IsNullOrWhiteSpace(userId)) return (null, "Unable to identify the signed-in user.");

            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return (null, NotFound);
            var closed = ClosedError(entity);
            if (closed != null) return (null, closed);
            if (entity.ApprovedDate == null)
                return (null, "The proposed actions are not approved yet, so they cannot be verified.");

            var details = (request.VerificationDetails ?? string.Empty).Trim();
            if (details.Length == 0) return (null, "Write what was observed when the actions were verified.");

            var dbContext = _repository.GetDbContext();
            var now = DateTime.UtcNow;
            entity.VerificationDetails = details;
            entity.VerifiedByAuditorUserId = userId;
            entity.VerifiedDate = now;

            var log = await dbContext.Set<NcarMonitoringLog>()
                .FirstOrDefaultAsync(l => l.NonconformingActionReportId == id, cancellationToken)
                .ConfigureAwait(false);
            if (log != null)
            {
                log.DateVerified = now;
                log.VerifiedByAuditorName = await UserNameAsync(userId, cancellationToken).ConfigureAwait(false);
            }

            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            await NotifyAsync(entity, userId, IqaNotifier.Types.NcarVerified,
                "NCAR verified - waiting for your validation",
                "{who} verified the actions of NCAR {ref}. Validate it to close the NCAR.",
                await LeadAuditorsOfAsync(entity, cancellationToken).ConfigureAwait(false), cancellationToken).ConfigureAwait(false);
            return await Saved(id, cancellationToken).ConfigureAwait(false);
        }

        public async Task<(NonconformingActionReportDto? Ncar, string? Error)> ValidateAndCloseAsync(
            long id, string userId, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(userId)) return (null, "Unable to identify the signed-in user.");

            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return (null, NotFound);
            var closed = ClosedError(entity);
            if (closed != null) return (null, closed);
            if (entity.VerifiedDate == null)
                return (null, "The actions have not been verified yet, so the NCAR cannot be closed.");

            var dbContext = _repository.GetDbContext();
            var now = DateTime.UtcNow;
            entity.ValidatedByLeadAuditorUserId = userId;
            entity.ValidatedDate = now;
            entity.IsClosed = true;
            entity.IsActive = false;

            var log = await dbContext.Set<NcarMonitoringLog>()
                .FirstOrDefaultAsync(l => l.NonconformingActionReportId == id, cancellationToken)
                .ConfigureAwait(false);
            if (log != null)
            {
                log.DateValidated = now;
                log.Remarks = "Closed";
            }

            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            var officeHeads = await IqaNotifier.OfficeHeadsByNameAsync(dbContext, entity.Office, cancellationToken).ConfigureAwait(false);
            var closedFor = new List<string?>(officeHeads) { entity.IssuedByAuditorUserId, entity.ProposedByAuditeeUserId };
            await NotifyAsync(entity, userId, IqaNotifier.Types.NcarClosed,
                "NCAR closed",
                "{who} validated and closed NCAR {ref}.",
                closedFor, cancellationToken).ConfigureAwait(false);
            return await Saved(id, cancellationToken).ConfigureAwait(false);
        }

        // ------------------------------------------------------------------
        // Notifications (the IQA bell). Raised once the step is saved; a failure
        // here never fails the step. "{who}" and "{ref}" are filled in here.
        // ------------------------------------------------------------------

        private async Task NotifyAsync(
            NonconformingActionReport ncar, string actorUserId, string type, string title, string message,
            IEnumerable<string?> recipients, CancellationToken cancellationToken)
        {
            try
            {
                var dbContext = _repository.GetDbContext();
                var who = await IqaNotifier.NameOfAsync(dbContext, actorUserId, cancellationToken).ConfigureAwait(false);

                await IqaNotifier.AddAsync(
                    dbContext, recipients, actorUserId, type, title,
                    message.Replace("{who}", who).Replace("{ref}", ncar.ReferenceNumber),
                    IqaNotifier.Entities.Ncar, ncar.Id, IqaNotifier.Pages.Ncar, cancellationToken).ConfigureAwait(false);
                await IqaNotifier.SaveSafelyAsync(dbContext, cancellationToken).ConfigureAwait(false);
            }
            catch (Exception)
            {
                // a notification must never fail the step
            }
        }

        /// <summary>
        /// Who validates and closes an NCAR: the Lead Auditors and the leaders of
        /// the audit team the NCAR came from.
        /// </summary>
        private async Task<List<string?>> LeadAuditorsOfAsync(NonconformingActionReport ncar, CancellationToken cancellationToken)
        {
            var result = new List<string?>();
            try
            {
                var dbContext = _repository.GetDbContext();
                result.AddRange(await IqaNotifier.UsersInRoleAsync(dbContext, IqaNotifier.LeadAuditorRoleName, cancellationToken).ConfigureAwait(false));

                if (ncar.AuditChecklistId != null)
                {
                    var scheduleId = await dbContext.Set<AuditChecklist>()
                        .AsNoTracking()
                        .Where(c => c.Id == ncar.AuditChecklistId)
                        .Select(c => (int?)c.AuditScheduleId)
                        .FirstOrDefaultAsync(cancellationToken)
                        .ConfigureAwait(false);
                    if (scheduleId != null)
                    {
                        var teams = await IqaNotifier.ScheduleTeamIdsAsync(dbContext, scheduleId.Value, cancellationToken).ConfigureAwait(false);
                        if (teams.Count > 0)
                            result.AddRange(await IqaNotifier.TeamLeadersAsync(dbContext, teams, cancellationToken).ConfigureAwait(false));
                    }
                }
            }
            catch (Exception)
            {
                // recipients are best effort
            }
            return result;
        }

        /// <summary>Raises (or refreshes) the monitoring log line of an approved NCAR.</summary>
        private async Task SyncMonitoringLogAsync(long ncarId, CancellationToken cancellationToken)
        {
            var ncar = await _repository.GetByIdWithDetailsAsync(ncarId, cancellationToken).ConfigureAwait(false);
            if (ncar == null) return;

            await _monitoringLogService.SyncFromNcarAsync(
                ncarId,
                ncar.Office,
                ncar.IssuedDate ?? ncar.AuditDate,
                NonconformingActionReportDto.FullName(ncar.IssuedByAuditor) ?? "Auditor",
                ncar.RelevantStandard,
                NonconformingActionReportDto.FullName(ncar.AcknowledgedByAuditee) ?? ncar.Office,
                cancellationToken).ConfigureAwait(false);
        }

        private async Task<string> UserNameAsync(string userId, CancellationToken cancellationToken)
        {
            var user = await _repository.GetDbContext().Set<User>()
                .AsNoTracking()
                .FirstOrDefaultAsync(u => u.Id == userId, cancellationToken)
                .ConfigureAwait(false);
            return NonconformingActionReportDto.FullName(user) ?? "Auditor";
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
