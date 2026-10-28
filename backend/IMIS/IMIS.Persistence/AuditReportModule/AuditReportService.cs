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

            var entity = aDto.ToEntity();
            var dbContext = _repository.GetDbContext();

            if (entity.Id == 0)
            {
                dbContext.Add(entity);

                var addedEntry = dbContext.Entry(entity);
                addedEntry.Property<int?>("AuditeeId").CurrentValue = aDto.AuditeeId;
                addedEntry.Property<int?>("OfficeAuditedId").CurrentValue = aDto.OfficeAuditedId;
                addedEntry.Property<long?>("AuditStandardISOId").CurrentValue = aDto.AuditStandardISOId;
                addedEntry.Property<int?>("AuditPlanEntryId").CurrentValue = aDto.AuditPlanEntryId;
            }
            else
            {
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken).ConfigureAwait(false);
                if (existing != null)
                {
                    if (existing.AuditComFindings?.Any() == true)
                        dbContext.Set<AuditComFindings>().RemoveRange(existing.AuditComFindings);

                    if (existing.AuditScope?.Any() == true)
                        dbContext.Set<AuditScope>().RemoveRange(existing.AuditScope);

                    if (existing.AuditSummaryFIndings?.Any() == true)
                        dbContext.Set<AuditSummaryFIndings>().RemoveRange(existing.AuditSummaryFIndings);

                    dbContext.Entry(existing).CurrentValues.SetValues(entity);

                    var existingEntry = dbContext.Entry(existing);
                    existingEntry.Property<int?>("AuditeeId").CurrentValue = aDto.AuditeeId;
                    existingEntry.Property<int?>("OfficeAuditedId").CurrentValue = aDto.OfficeAuditedId;
                    existingEntry.Property<long?>("AuditStandardISOId").CurrentValue = aDto.AuditStandardISOId;
                    existingEntry.Property<int?>("AuditPlanEntryId").CurrentValue = aDto.AuditPlanEntryId;
                }
            }

            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            // The three child collections are nulled out in AuditReportDto.ToEntity()
            // (the parent must be tracked without them), so the DTO's rows have to be
            // re-attached here. This runs AFTER the parent insert so entity.Id is the
            // real generated key, and it re-keys the children to that id rather than
            // trusting whatever AuditReportId the client sent. AuditReportId is
            // required + FK on all three child entities, so without this block the
            // commendable findings / auditees / summary-of-findings rows were deleted
            // on update and never re-created — silently discarding the user's input.
            AddChildCollections(dbContext, aDto, entity.Id);

            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            aDto.Id = entity.Id;
        }

        private static void AddChildCollections(DbContext dbContext, AuditReportDto dto, int auditReportId)
        {
            // Children are built with an object initializer rather than ToEntity()
            // because Id/RowVersion are init-only and cannot be reset after the
            // fact. Every child is re-inserted instead of updated: the existing rows
            // were removed just above, so carrying the client's Id over would make
            // EF issue an INSERT against a primary key that was deleted moments
            // earlier and fail with a PK violation. The DTO's child Ids therefore
            // only identify "which row this was", not what to persist.
            foreach (var child in dto.AuditComFindings ?? new List<AuditComFindingsDto>())
            {
                if (child == null) continue;
                dbContext.Set<AuditComFindings>().Add(new AuditComFindings
                {
                    Id = 0,
                    CommendableFindings = child.CommendableFindings,
                    Area = child.AreasId ?? 0,
                    AuditReportId = auditReportId,
                    IsDeleted = false
                });
            }

            foreach (var child in dto.AuditScope ?? new List<AuditScopeDto>())
            {
                if (child == null) continue;
                dbContext.Set<AuditScope>().Add(new AuditScope
                {
                    Id = 0,
                    Auditee = child.Auditee,
                    TeamId = child.TeamId,
                    AuditReportId = auditReportId,
                    IsDeleted = false
                });
            }

            foreach (var child in dto.AuditSummaryFindings ?? new List<AuditSummaryFindingsDto>())
            {
                if (child == null) continue;
                dbContext.Set<AuditSummaryFIndings>().Add(new AuditSummaryFIndings
                {
                    Id = 0,
                    No = child.No,
                    Findings = child.Findings,
                    AuditNcarStatusId = child.AuditNcarStatusId,
                    AuditReportId = auditReportId,
                    IsDeleted = false
                });
            }
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
