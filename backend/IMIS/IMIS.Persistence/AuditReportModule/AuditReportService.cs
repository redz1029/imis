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
            // entry, office, standard and auditees come from the checklist, so
            // whatever the client echoes for them is ignored. The Summary of
            // Findings is saved by SaveSummaryFindingsAsync.
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

            await SaveSummaryFindingsAsync(existing.Id, aDto.AuditSummaryFindings, cancellationToken).ConfigureAwait(false);

            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Summary of Findings. The lines fetched from the checklist (one per
        /// non-conforming clause) keep their clause, status and NCAR; the auditor
        /// only writes their Findings. Lines the auditor added are saved whole
        /// (criteria, findings, NC or OFI) and removed when left out.
        /// </summary>
        private async Task SaveSummaryFindingsAsync(
            int auditReportId,
            ICollection<AuditSummaryFindingsDto>? incoming,
            CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();
            var sent = (incoming ?? new List<AuditSummaryFindingsDto>())
                .Where(d => d != null)
                .ToList();

            var statuses = await dbContext.Set<AuditNcarStatus>()
                .AsNoTracking()
                .Where(s => s.ncarStatus != null)
                .Select(s => new { s.Id, Name = s.ncarStatus!.Trim().ToUpper() })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
            var ncId = statuses.FirstOrDefault(s => s.Name == "NC")?.Id;
            var ofiId = statuses.FirstOrDefault(s => s.Name == "OFI")?.Id;

            var current = await dbContext.Set<AuditSummaryFIndings>()
                .Where(f => f.AuditReportId == auditReportId && !f.IsDeleted)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            var sentById = sent.Where(d => d.Id > 0).GroupBy(d => d.Id).ToDictionary(g => g.Key, g => g.First());

            foreach (var line in current)
            {
                var fetched = line.AuditChecklistId != null;
                if (!sentById.TryGetValue(line.Id, out var dto))
                {
                    // Fetched lines follow the checklist and cannot be removed here.
                    if (!fetched && line.CriteriaText != null)
                        dbContext.Set<AuditSummaryFIndings>().Remove(line);
                    continue;
                }

                line.Findings = (dto.Findings ?? string.Empty).Trim();
                if (fetched || line.CriteriaText == null) continue;

                line.CriteriaText = (dto.CriteriaText ?? string.Empty).Trim();
                line.AuditNcarStatusId = ResolveStatus(dto.AuditNcarStatusId, ncId, ofiId);
            }

            // Manual lines in the order the form lists them, new ones included.
            var manual = new List<(int Index, AuditSummaryFIndings Line)>();
            var currentIds = current.Select(f => f.Id).ToHashSet();
            for (var i = 0; i < sent.Count; i++)
            {
                var dto = sent[i];
                if (currentIds.Contains(dto.Id))
                {
                    var line = current.First(f => f.Id == dto.Id);
                    if (IsManualLine(line)) manual.Add((i, line));
                    continue;
                }

                var criteria = (dto.CriteriaText ?? string.Empty).Trim();
                var findings = (dto.Findings ?? string.Empty).Trim();
                // A line with nothing written is just an empty row.
                if (criteria.Length == 0 && findings.Length == 0) continue;

                var added = new AuditSummaryFIndings
                {
                    Id = 0,
                    No = 0,
                    Findings = findings,
                    CriteriaText = criteria,
                    AuditChecklistId = null,
                    NcarReferenceNumber = null,
                    AuditNcarStatusId = ResolveStatus(dto.AuditNcarStatusId, ncId, ofiId),
                    AuditReportId = auditReportId,
                    IsDeleted = false
                };
                dbContext.Set<AuditSummaryFIndings>().Add(added);
                manual.Add((i, added));
            }

            // Numbering: the lines from the checklist first, in the order they
            // were raised, then the manual ones as listed on the form.
            var no = 1;
            foreach (var line in current.Where(f => !IsManualLine(f)).OrderBy(f => f.No).ThenBy(f => f.Id))
                line.No = no++;
            foreach (var m in manual.OrderBy(m => m.Index))
                m.Line.No = no++;
        }

        /// <summary>
        /// A line typed on the report: it has no checklist row, but it does have a
        /// criteria (possibly empty). Lines with neither predate the editable report.
        /// </summary>
        private static bool IsManualLine(AuditSummaryFIndings line) =>
            line.AuditChecklistId == null && line.CriteriaText != null;

        private static int? ResolveStatus(int? requested, int? ncId, int? ofiId) =>
            requested.HasValue && (requested == ncId || requested == ofiId) ? requested : ncId;

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
            if (entity == null) return null;

            var dto = new AuditReportDto(entity);
            dto.AuditorNames = await GetAuditorNamesAsync(entity.AuditScheduleId, cancellationToken).ConfigureAwait(false);
            return dto;
        }

        /// <summary>
        /// The audit team of the schedule: every member of its team (the team
        /// leader first), plus any auditor named on the plan entry who is not on
        /// the roster. Real names come from the auditors' user accounts.
        /// </summary>
        private async Task<List<string>> GetAuditorNamesAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();

            var schedule = await dbContext.Set<AuditSchedule>()
                .AsNoTracking()
                .Include(s => s.AuditPlanEntry!)
                    .ThenInclude(e => e!.IsoAuditors)
                .FirstOrDefaultAsync(s => s.Id == auditScheduleId, cancellationToken)
                .ConfigureAwait(false);
            if (schedule == null) return new List<string>();

            var entryAuditors = (schedule.AuditPlanEntry?.IsoAuditors ?? new List<IsoAuditor>())
                .Where(a => !a.IsDeleted)
                .ToList();
            var teamId = schedule.TeamId ?? entryAuditors.FirstOrDefault(a => a.TeamId != null)?.TeamId;

            var members = new List<(int AuditorId, string Name, bool Leader)>();
            if (teamId.HasValue)
            {
                var roster = await dbContext.Set<AuditorTeams>()
                    .AsNoTracking()
                    .Include(t => t.Auditor)
                        .ThenInclude(a => a!.User)
                    .Where(t => !t.IsDeleted && t.TeamId == teamId.Value && t.AuditorId != null && t.Auditor != null)
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
                foreach (var row in roster)
                {
                    var auditorId = row.AuditorId!.Value;
                    var existing = members.FindIndex(m => m.AuditorId == auditorId);
                    if (existing >= 0)
                    {
                        if (row.IsTeamLeader) members[existing] = (auditorId, members[existing].Name, true);
                        continue;
                    }
                    members.Add((auditorId, AuditChecklistService.AuditorName(row.Auditor!), row.IsTeamLeader));
                }
            }

            var extraIds = entryAuditors
                .Where(a => a.AuditorId != null && !members.Any(m => m.AuditorId == a.AuditorId))
                .Select(a => a.AuditorId!.Value)
                .Distinct()
                .ToList();
            if (extraIds.Count > 0)
            {
                var extras = await dbContext.Set<Auditor>()
                    .AsNoTracking()
                    .Include(a => a.User)
                    .Where(a => !a.IsDeleted && extraIds.Contains(a.Id))
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
                foreach (var a in extras)
                    members.Add((a.Id, AuditChecklistService.AuditorName(a), false));
            }

            return members
                .OrderByDescending(m => m.Leader)
                .ThenBy(m => m.Name)
                .Select(m => m.Name)
                .Where(n => !string.IsNullOrWhiteSpace(n))
                .Distinct()
                .ToList();
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
