using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditReportModule;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Domain;

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
                    if (existing.RootCauses?.Any() == true)
                        dbContext.Set<NcarRootCause>().RemoveRange(existing.RootCauses);

                    if (existing.Corrections?.Any() == true)
                        dbContext.Set<NcarCorrectionAction>().RemoveRange(existing.Corrections);

                    if (existing.CorrectiveActions?.Any() == true)
                        dbContext.Set<NcarCorrectiveAction>().RemoveRange(existing.CorrectiveActions);

                    dbContext.Entry(existing).CurrentValues.SetValues(entity);

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

        public async Task<NonconformingActionReportDto?> CreateFromAuditReportAsync(int auditReportId, string issuedByAuditorUserId, string acknowledgedByAuditeeUserId, CancellationToken cancellationToken)
        {
            var existingNcar = await _repository.GetByAuditReportIdAsync(auditReportId, cancellationToken).ConfigureAwait(false);
            if (existingNcar != null)
                return new NonconformingActionReportDto(existingNcar);

            var auditReport = await _auditReportRepository.GetByIdWithDetailsAsync(auditReportId, cancellationToken).ConfigureAwait(false);
            if (auditReport == null) return null;

            var findingsText = auditReport.AuditSummaryFIndings != null && auditReport.AuditSummaryFIndings.Any()
                ? string.Join(Environment.NewLine, auditReport.AuditSummaryFIndings.Select(f => f.Findings))
                : auditReport.AuditConclisions;

            var standardRef = auditReport.AuditStandardISO?.ClauseRef ?? string.Empty;
            var officeName = auditReport.OfficeAudited?.Office?.Name ?? auditReport.OfficeAudited?.ProcessName ?? string.Empty;

            var referenceNumber = $"NCAR-{DateTime.UtcNow:yyyy}-{auditReport.Id:D4}";

            var entity = new NonconformingActionReport
            {
                Id = 0,
                ReferenceNumber = referenceNumber,
                Office = officeName,
                RelevantStandard = standardRef,
                AuditDate = auditReport.AuditPlanEntry?.Time ?? DateTime.UtcNow,

                IsInternalAudit = true,
                IsNonconformity = true,

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
    }
}
