using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.IQASignatoryModule;
using IMIS.Application.IqaNotificationModule;
using IMIS.Application.IQASignatoryTemplateModule;
using IMIS.Application.OfficeModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.IQASignatoryModule
{
    public class IQAAuditSignatoryService : IIQAAuditSignatoryService
    {
        private readonly IIQASignatoryRepository _signatoryRepository;
        private readonly IIQASignatoryTemplateRepository _templateRepository;
        private readonly IOfficeRepository _officeRepository;
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly ImisDbContext _dbContext;

        public IQAAuditSignatoryService(
            IIQASignatoryRepository signatoryRepository,
            IIQASignatoryTemplateRepository templateRepository,
            IOfficeRepository officeRepository,
            UserManager<User> userManager,
            RoleManager<IdentityRole> roleManager,
            ImisDbContext dbContext)
        {
            _signatoryRepository = signatoryRepository ?? throw new ArgumentNullException(nameof(signatoryRepository));
            _templateRepository = templateRepository ?? throw new ArgumentNullException(nameof(templateRepository));
            _officeRepository = officeRepository ?? throw new ArgumentNullException(nameof(officeRepository));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _roleManager = roleManager ?? throw new ArgumentNullException(nameof(roleManager));
            _dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
        }

        public async Task<List<IQASignatoryDto>?> GetAllByAuditEntityTypeAsync(
            string auditEntityType,
            CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(auditEntityType))
                return new List<IQASignatoryDto>();

            var signatories = await _dbContext.Set<IQASignatory>()
                .Where(s => s.AuditEntityType == auditEntityType && !s.IsDeleted)
                .Include(s => s.IQASignatoryTemplate)
                .OrderBy(s => s.AuditEntityId)
                .ThenBy(s => s.IQASignatoryTemplate!.OrderLevel)
                .ToListAsync(cancellationToken);

            return signatories.Select(s => new IQASignatoryDto(s)).ToList();
        }

        public async Task<List<IQASignatoryDto>?> GetByAuditEntityIdAsync(
            string auditEntityType,
            int auditEntityId,
            CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(auditEntityType) || auditEntityId <= 0)
                return new List<IQASignatoryDto>();

            // The three typed cases below go through repository methods that
            // filter on the dedicated FK (AuditProgrammeId / AuditPlanId /
            // AuditScheduleId). Any other entity type — "AuditReport" today,
            // anything added later — has no such FK, so it falls back to the
            // generic (AuditEntityType, AuditEntityId) pair that
            // SubmitForApprovalAsync always populates. Without this fallback
            // every approval read/write for a new entity type silently
            // returned an empty chain.
            IEnumerable<IQASignatory> signatories = auditEntityType switch
            {
                "AuditProgramme" => await _signatoryRepository.GetByAuditProgrammeIdAsync(auditEntityId, cancellationToken),
                "AuditPlan" => await _signatoryRepository.GetByAuditPlanIdAsync(auditEntityId, cancellationToken),
                "AuditSchedule" => await _signatoryRepository.GetByAuditScheduleIdAsync(auditEntityId, cancellationToken),
                _ => await _dbContext.Set<IQASignatory>()
                        .Where(s => s.AuditEntityType == auditEntityType && s.AuditEntityId == auditEntityId)
                        .Include(s => s.IQASignatoryTemplate)
                        .ToListAsync(cancellationToken)
            };

            return signatories
                .Where(s => !s.IsDeleted)
                .OrderBy(s => s.IQASignatoryTemplate?.OrderLevel ?? int.MaxValue)
                .Select(s => new IQASignatoryDto(s))
                .ToList();
        }

        public async Task<DtoPageList<IQASignatoryDto, IQASignatory, long>> GetPaginatedAsync(
            string auditEntityType,
            int page,
            int pageSize,
            CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(auditEntityType) || page < 1 || pageSize < 1)
                return DtoPageList<IQASignatoryDto, IQASignatory, long>.Create(new List<IQASignatory>(), page, pageSize, 0);

            var query = _dbContext.Set<IQASignatory>()
                .Where(s => s.AuditEntityType == auditEntityType && !s.IsDeleted)
                .Include(s => s.IQASignatoryTemplate)
                .OrderBy(s => s.AuditEntityId)
                .ThenBy(s => s.IQASignatoryTemplate!.OrderLevel);

            var totalCount = await query.CountAsync(cancellationToken);
            var items = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync(cancellationToken);

            return DtoPageList<IQASignatoryDto, IQASignatory, long>.Create(items, page, pageSize, totalCount);
        }

        public async Task<List<IQASignatoryTemplate>> GetInheritedTemplatesAsync(
            int officeId,
            string auditEntityType,
            CancellationToken cancellationToken)
        {
            if (officeId <= 0 || string.IsNullOrWhiteSpace(auditEntityType))
                return new List<IQASignatoryTemplate>();

            var templates = (await _templateRepository.GetByOfficeIdAsync(officeId, cancellationToken))
                .Where(t => t.AuditEntityType == auditEntityType && !t.IsDeleted)
                .OrderBy(t => t.OrderLevel)
                .ToList();

            if (templates.Any())
                return templates;

            var office = await _officeRepository.GetByIdAsync(officeId, cancellationToken);
            if (office?.ParentOfficeId == null || office.ParentOfficeId <= 0)
                return new List<IQASignatoryTemplate>();

            return await GetInheritedTemplatesAsync(office.ParentOfficeId.Value, auditEntityType, cancellationToken);
        }

        // NOTE: this method computes `isDraft` but never uses it — it returns an
        // effectively empty DTO regardless of input. Left unchanged because I
        // don't know what this endpoint is supposed to return; tell me its
        // intended behavior (e.g. "return the next pending signatory, or a
        // blank template if none exist yet") and I'll implement it properly.
        public async Task<IQASignatoryDto?> ProcessSignatoriesAsync(
            string auditEntityType,
            int auditEntityId,
            string userId,
            CancellationToken cancellationToken)
        {
            var existing = await GetByAuditEntityIdAsync(auditEntityType, auditEntityId, cancellationToken) ?? new();
            var isDraft = !existing.Any(s => s.Id > 0);

            return new IQASignatoryDto
            {
                Id = 0,
                AuditEntityType = auditEntityType,
                AuditEntityId = auditEntityId
            };
        }

        public async Task<IQASignatoryDto> SaveOrUpdateAsync(
            IQASignatoryDto dto,
            CancellationToken cancellationToken)
        {
            if (dto == null)
                throw new ArgumentNullException(nameof(dto));

            var entity = dto.ToEntity();
            await _signatoryRepository.SaveOrUpdateAsync(entity, cancellationToken);

            var saved = await _signatoryRepository.GetByIdAsync(entity.Id, cancellationToken);
            return new IQASignatoryDto(saved!);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(
            BaseDto<TEntity, TId> dto,
            CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not IQASignatoryDto signDto)
                throw new ArgumentException("Invalid DTO type", nameof(dto));

            var entity = signDto.ToEntity();
            await _signatoryRepository.SaveOrUpdateAsync(entity, cancellationToken);
        }

        // UNCONFIRMED — does not resolve an office for AuditProgramme, since
        // AuditProgramme has no OfficeId in what you've shown me. This grabs
        // every template for the entity type regardless of office, which is
        // only correct if that's actually the intended behavior for
        // AuditProgramme specifically. For AuditPlan/AuditSchedule, which DO
        // have real offices via their linked entries, this should probably
        // call GetInheritedTemplatesAsync(officeId, ...) instead — tell me
        // how to get the relevant officeId for each entity type and I'll wire
        // it in correctly rather than leave this office-blind.
        public async Task<bool> SubmitForApprovalAsync(
            string auditEntityType,
            int auditEntityId,
            string userId,
            CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(auditEntityType) || auditEntityId <= 0 || string.IsNullOrWhiteSpace(userId))
                return false;

            var templates = (await _templateRepository.GetByAuditEntityTypeAsync(auditEntityType, cancellationToken))
                .Where(t => !t.IsDeleted)
                .OrderBy(t => t.OrderLevel)
                .ToList();
            var reportApprovers = new List<string>();

            foreach (var template in templates)
            {
                if (string.IsNullOrEmpty(template.DefaultSignatoryId))
                    continue;

                var signatory = new IQASignatory
                {
                    Id = 0,
                    AuditEntityType = auditEntityType,
                    AuditEntityId = auditEntityId,
                    IQASignatoryTemplateId = template.Id,
                    SignatoryId = template.DefaultSignatoryId,
                    ApprovalStatus = "Pending"
                };

                switch (auditEntityType)
                {
                    case "AuditProgramme":
                        signatory.AuditProgrammeId = auditEntityId;
                        break;
                    case "AuditPlan":
                        signatory.AuditPlanId = auditEntityId;
                        break;
                    case "AuditSchedule":
                        signatory.AuditScheduleId = auditEntityId;
                        break;
                }

                await _signatoryRepository.SaveOrUpdateAsync(signatory, cancellationToken);
                if (string.Equals(auditEntityType, IqaNotifier.Entities.AuditReport, StringComparison.Ordinal))
                    reportApprovers.Add(template.DefaultSignatoryId);
            }

            if (reportApprovers.Count > 0)
                await NotifyReportApproversAsync(auditEntityId, reportApprovers, userId, cancellationToken);

            return true;
        }

        // ------------------------------------------------------------------
        // Notifications (the IQA bell) for the Audit Report, which is approved
        // through this service. They never fail the submission or the decision.
        // ------------------------------------------------------------------

        private async Task<string> ReportOfficeAsync(int reportId, CancellationToken cancellationToken)
        {
            var office = await _dbContext.Set<AuditReport>()
                .AsNoTracking()
                .Where(r => r.Id == reportId)
                .Select(r => r.OfficeAudited == null ? null : (r.OfficeAudited.Office != null ? r.OfficeAudited.Office.Name : r.OfficeAudited.ProcessName))
                .FirstOrDefaultAsync(cancellationToken);
            return string.IsNullOrWhiteSpace(office) ? "" : $" of {office}";
        }

        private async Task NotifyReportApproversAsync(
            int reportId, List<string> approvers, string userId, CancellationToken cancellationToken)
        {
            try
            {
                var resubmitted = await _dbContext.Set<IqaNotification>()
                    .AsNoTracking()
                    .AnyAsync(n => n.EntityType == IqaNotifier.Entities.AuditReport && n.EntityId == reportId &&
                                   (n.Type == IqaNotifier.Types.Submitted || n.Type == IqaNotifier.Types.Resubmitted),
                              cancellationToken);
                var who = await IqaNotifier.NameOfAsync(_dbContext, userId, cancellationToken);
                var office = await ReportOfficeAsync(reportId, cancellationToken);
                var verb = resubmitted ? "resubmitted" : "submitted";

                await IqaNotifier.AddAsync(
                    _dbContext, approvers, userId,
                    resubmitted ? IqaNotifier.Types.Resubmitted : IqaNotifier.Types.Submitted,
                    $"Audit Report {verb} for approval",
                    $"{who} {verb} the audit report{office} for your approval.",
                    IqaNotifier.Entities.AuditReport, reportId, IqaNotifier.Pages.Report, cancellationToken);
                await IqaNotifier.SaveSafelyAsync(_dbContext, cancellationToken);
            }
            catch (Exception)
            {
                // a notification must never fail the submission
            }
        }

        private async Task NotifyReportDecisionAsync(
            int reportId, string approverId, bool approve, string? remarks,
            bool stillPending, CancellationToken cancellationToken)
        {
            try
            {
                var submitter = await IqaNotifier.SubmitterAsync(
                    _dbContext, IqaNotifier.Entities.AuditReport, reportId, cancellationToken);
                if (string.IsNullOrWhiteSpace(submitter)) return;

                var who = await IqaNotifier.NameOfAsync(_dbContext, approverId, cancellationToken);
                var office = await ReportOfficeAsync(reportId, cancellationToken);

                string type, title, message;
                if (!approve)
                {
                    type = IqaNotifier.Types.Rejected;
                    title = "Audit Report rejected";
                    message = $"{who} rejected the audit report{office}. Reason: {remarks}";
                }
                else if (stillPending)
                {
                    type = IqaNotifier.Types.Approved;
                    title = $"Audit Report approved by {who}";
                    message = $"{who} approved the audit report{office}. It is still waiting on the other approvers.";
                }
                else
                {
                    type = IqaNotifier.Types.FullyApproved;
                    title = "Audit Report approved";
                    message = $"{who} approved the audit report{office}. It is fully approved.";
                }

                await IqaNotifier.AddAsync(
                    _dbContext, new[] { submitter }, approverId, type, title, message,
                    IqaNotifier.Entities.AuditReport, reportId, IqaNotifier.Pages.Report, cancellationToken);
                await IqaNotifier.SaveSafelyAsync(_dbContext, cancellationToken);
            }
            catch (Exception)
            {
                // a notification must never fail the decision
            }
        }

        public async Task<bool> ApproveOrDisapproveAsync(
            string auditEntityType,
            int auditEntityId,
            string signatoryId,
            bool approve,
            string? remarks,
            CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(auditEntityType) || auditEntityId <= 0 || string.IsNullOrWhiteSpace(signatoryId))
                return false;

            var signatories = await GetByAuditEntityIdAsync(auditEntityType, auditEntityId, cancellationToken) ?? new();
            var currentSig = signatories.FirstOrDefault(s => s.SignatoryId == signatoryId && s.ApprovalStatus == "Pending");

            if (currentSig == null)
                return false;

            if (approve)
            {
                currentSig.ApprovalStatus = "Approved";
                currentSig.DateSigned = DateTime.UtcNow;
                currentSig.Remarks = remarks;

                await SaveOrUpdateAsync(currentSig, cancellationToken);

                if (string.Equals(auditEntityType, IqaNotifier.Entities.AuditReport, StringComparison.Ordinal))
                {
                    var stillPending = signatories.Any(s => s.Id != currentSig.Id && s.ApprovalStatus == "Pending");
                    await NotifyReportDecisionAsync(auditEntityId, signatoryId, true, remarks, stillPending, cancellationToken);
                }
            }
            else
            {
                // FIX: previously this reset every signatory (soft-delete) and
                // then unconditionally re-saved `currentSig` afterwards, which
                // re-wrote it back as a live "Pending" row — undoing the very
                // disapproval it was supposed to record, and the remarks were
                // never persisted anywhere. Now the disapproval status and
                // remarks are set on currentSig FIRST and saved, and the reset
                // of the OTHER (still-pending, downstream) signatories happens
                // after, without touching currentSig again.
                currentSig.ApprovalStatus = "Disapproved";
                currentSig.DateSigned = DateTime.UtcNow;
                currentSig.Remarks = remarks;
                await SaveOrUpdateAsync(currentSig, cancellationToken);

                var others = signatories.Where(s => s.Id != currentSig.Id).ToList();
                foreach (var sig in others)
                {
                    sig.IsDeleted = true;
                    await SaveOrUpdateAsync(sig, cancellationToken);
                }

                if (string.Equals(auditEntityType, IqaNotifier.Entities.AuditReport, StringComparison.Ordinal))
                    await NotifyReportDecisionAsync(auditEntityId, signatoryId, false, remarks, false, cancellationToken);
            }

            return true;
        }

        public async Task<IQASignatoryDto?> GetNextSignatoryAsync(
            string auditEntityType,
            int auditEntityId,
            CancellationToken cancellationToken)
        {
            // FIX: was `OrderBy(s => s.IQASignatoryTemplateId)` — that's the
            // template's own row id, unrelated to approval sequence.
            // GetByAuditEntityIdAsync above already orders by the template's
            // real OrderLevel, so just take the first pending one here.
            var signatories = await GetByAuditEntityIdAsync(auditEntityType, auditEntityId, cancellationToken) ?? new();
            return signatories.FirstOrDefault(s => s.ApprovalStatus == "Pending");
        }

        // FIX: this method used to be the source of the disapproval bug above
        // (it soft-deleted everyone, then ApproveOrDisapproveAsync silently
        // re-saved the current row un-deleted). It's no longer called from
        // ApproveOrDisapproveAsync's disapprove branch. Kept here as a
        // standalone "start over" operation — e.g. if a resubmission needs to
        // wipe the whole prior approval chain and generate fresh Pending rows
        // via SubmitForApprovalAsync again.
        public async Task<bool> ResetOnDisapprovalAsync(
            string auditEntityType,
            int auditEntityId,
            CancellationToken cancellationToken)
        {
            var signatories = await GetByAuditEntityIdAsync(auditEntityType, auditEntityId, cancellationToken) ?? new();

            foreach (var sig in signatories)
            {
                sig.IsDeleted = true;
                await SaveOrUpdateAsync(sig, cancellationToken);
            }

            return true;
        }

        public async Task<List<dynamic>> GetPendingForCurrentUserAsync(
            string roleId,
            int page,
            int pageSize,
            CancellationToken cancellationToken)
        {
            return new List<dynamic>();
        }

        public async Task<bool> IsDraftAsync(
            string auditEntityType,
            int auditEntityId,
            CancellationToken cancellationToken)
        {
            var signatories = await GetByAuditEntityIdAsync(auditEntityType, auditEntityId, cancellationToken) ?? new();
            return !signatories.Any(s => s.Id > 0);
        }
    }
}