using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditComFindingsModule;
using IMIS.Application.AuditReportModule;
using IMIS.Application.AuditScopeModule;
using IMIS.Application.AuditSummaryFindingsModule;
using IMIS.Domain;
using IMIS.Persistence.AuditChecklistModule;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditReportModule
{
    public class AuditReportService : IAuditReportService
    {
        private readonly IAuditReportRepository _repository;

        public AuditReportService(IAuditReportRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SaveAuditReportAsync(AuditReportDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) return false;
            await SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
    where TEntity : Entity<TId>
        {
            if (dto is not AuditReportDto aDto)
                throw new InvalidOperationException("Invalid DTO type.");

            // A report is raised by the audit checklist (see AuditChecklistService.Report),
            // never typed in, so there is nothing here that can add one.
            if (aDto.Id == 0)
                throw new InvalidOperationException("Audit reports are created automatically from the audit checklist.");

            var dbContext = _repository.GetDbContext();

            var existing = await _repository.GetByIdWithDetailsAsync(aDto.Id, cancellationToken).ConfigureAwait(false);
            if (existing == null)
                throw new InvalidOperationException("Audit report not found.");

            // Only what the auditor writes by hand is saved. The schedule, plan
            // entry, office, standard, auditees and Summary of Findings come from
            // the checklist, so whatever the client echoes for them is ignored.
            if (existing.AuditComFindings?.Any() == true)
                dbContext.Set<AuditComFindings>().RemoveRange(existing.AuditComFindings);

            existing.AuditPurpose = aDto.AuditPurpose;
            existing.AuditConclisions = aDto.AuditConclusions;

            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            // The parent is tracked without its children, so the commendable
            // findings are re-attached here under the report's real id. Every
            // row is re-inserted: the old ones were removed above, so keeping
            // the client's Id would be an INSERT of a deleted primary key.
            foreach (var child in aDto.AuditComFindings ?? new List<AuditComFindingsDto>())
            {
                if (child == null) continue;
                dbContext.Set<AuditComFindings>().Add(new AuditComFindings
                {
                    Id = 0,
                    CommendableFindings = child.CommendableFindings,
                    Area = child.AreasId ?? 0,
                    AuditReportId = existing.Id,
                    IsDeleted = false
                });
            }

            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// One line per audit report with the checklist figures behind it, so the
        /// list can show how many clauses were non-conforming and how many NCARs
        /// they raised without loading every checklist row.
        /// </summary>
        public async Task<List<AuditReportFindingsSummaryDto>> GetFindingsSummariesAsync(CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var scheduleIds = await dbContext.Set<AuditReport>()
                .AsNoTracking()
                .Select(r => r.AuditScheduleId)
                .Distinct()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
            if (scheduleIds.Count == 0) return new List<AuditReportFindingsSummaryDto>();

            var counts = await dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => scheduleIds.Contains(c.AuditScheduleId) && !c.IsDeleted)
                .GroupBy(c => c.AuditScheduleId)
                .Select(g => new
                {
                    AuditScheduleId = g.Key,
                    Total = g.Count(),
                    Conforming = g.Count(c => c.Conforming == true),
                    NonConforming = g.Count(c => c.Conforming == false)
                })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            var ncarCounts = await (from n in dbContext.Set<NonconformingActionReport>().AsNoTracking()
                                    join c in dbContext.Set<AuditChecklist>().AsNoTracking() on n.AuditChecklistId equals c.Id
                                    where scheduleIds.Contains(c.AuditScheduleId)
                                    group n by c.AuditScheduleId into g
                                    select new { AuditScheduleId = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.AuditScheduleId, x => x.Count, cancellationToken)
                .ConfigureAwait(false);

            return counts
                .Select(c => new AuditReportFindingsSummaryDto
                {
                    AuditScheduleId = c.AuditScheduleId,
                    TotalCount = c.Total,
                    ConformingCount = c.Conforming,
                    NonConformingCount = c.NonConforming,
                    PendingCount = c.Total - c.Conforming - c.NonConforming,
                    NcarCount = ncarCounts.TryGetValue(c.AuditScheduleId, out var n) ? n : 0
                })
                .ToList();
        }

        public async Task<AuditReportDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new AuditReportDto(entity) : null;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return false;

            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task<DtoPageList<AuditReportDto, AuditReport, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            // Uses explicit raw database collection arrays to perfectly satisfy base signatures
            return DtoPageList<AuditReportDto, AuditReport, int>.Create(
                result.Items,
                page,
                pageSize,
                result.TotalCount);
        }

        public async Task<IEnumerable<AuditReportDto>> GetByAuditScheduleIdAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            var entities = await _repository.GetByAuditScheduleIdAsync(auditScheduleId, cancellationToken).ConfigureAwait(false);
            return entities.Select(x => new AuditReportDto(x));
        }

        public async Task<AuditReportClauseResultsDto> GetClauseResultsAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var rows = await dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => c.AuditScheduleId == auditScheduleId && !c.IsDeleted)
                .Select(c => new
                {
                    c.Id,
                    Question = c.AuditChecklistQNA!.Question,
                    ClauseRef = c.AuditChecklistQNA.IsoStandard!.ClauseRef,
                    c.Conforming,
                    c.FindingAndRemarks
                })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            var rowIds = rows.Select(r => r.Id).ToList();
            var ncars = await dbContext.Set<NonconformingActionReport>()
                .AsNoTracking()
                .Where(n => n.AuditChecklistId != null && rowIds.Contains(n.AuditChecklistId.Value))
                .Select(n => new
                {
                    ChecklistId = n.AuditChecklistId!.Value,
                    n.Id,
                    n.ReferenceNumber,
                    n.IsClosed,
                    n.ApprovedDate,
                    n.AcknowledgedDate
                })
                .ToDictionaryAsync(n => n.ChecklistId, cancellationToken)
                .ConfigureAwait(false);

            var items = rows
                .OrderBy(r => r.ClauseRef, new ClauseNumberComparer())
                .Select(r =>
                {
                    var found = ncars.TryGetValue(r.Id, out var ncar);
                    return new AuditReportClauseResultDto
                    {
                        AuditChecklistId = r.Id,
                        ClauseRef = r.ClauseRef.Trim(),
                        Question = r.Question,
                        Conforming = r.Conforming,
                        FindingAndRemarks = r.FindingAndRemarks,
                        NcarId = found ? ncar!.Id : null,
                        NcarReferenceNumber = found ? ncar!.ReferenceNumber : null,
                        NcarStatus = found ? NcarStatusName(ncar!.IsClosed, ncar.ApprovedDate, ncar.AcknowledgedDate) : null
                    };
                })
                .ToList();

            return new AuditReportClauseResultsDto
            {
                AuditScheduleId = auditScheduleId,
                ConformingCount = items.Count(i => i.Conforming == true),
                NonConformingCount = items.Count(i => i.Conforming == false),
                PendingCount = items.Count(i => i.Conforming == null),
                Items = items
            };
        }

        private static string NcarStatusName(bool isClosed, DateTime? approvedDate, DateTime? acknowledgedDate)
        {
            if (isClosed) return "Closed";
            if (approvedDate != null) return "Under Monitoring";
            if (acknowledgedDate != null) return "Acknowledged / Under Review";
            return "Open / Issued";
        }
    }
}
