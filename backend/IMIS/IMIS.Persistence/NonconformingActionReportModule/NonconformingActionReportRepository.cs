using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.NonconformingActionReportModule
{
    public class NonconformingActionReportRepository : BaseRepository<NonconformingActionReport, long, ImisDbContext, User>, INonconformingActionReportRepository
    {
        public NonconformingActionReportRepository(ImisDbContext dbContext) : base(dbContext) { }

        public async Task<NonconformingActionReport?> GetByIdWithDetailsAsync(long id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<NonconformingActionReport>()
                .Include(x => x.AuditReport)
                .Include(x => x.IssuedByAuditor)
                .Include(x => x.AcknowledgedByAuditee)
                .Include(x => x.ProposedByAuditee)
                .Include(x => x.ApprovedByHead)
                .Include(x => x.VerifiedByAuditor)
                .Include(x => x.ValidatedByLeadAuditor)
                .Include(x => x.RootCauses)
                .Include(x => x.Corrections)
                .Include(x => x.CorrectiveActions)
                .AsSplitQuery()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<NonconformingActionReport, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<NonconformingActionReport, long>.CreateAsync(
                _entities.AsNoTracking()
                    .Include(x => x.AuditReport)
                    .Include(x => x.IssuedByAuditor)
                    .Include(x => x.AcknowledgedByAuditee),
                page,
                pageSize,
                cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<NonconformingActionReport?> GetByIdForDeleteAsync(long id, CancellationToken cancellationToken)
        {
            return await _entities
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<NonconformingActionReport?> GetByAuditReportIdAndTypeAsync(int auditReportId, bool isNonconformity, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<NonconformingActionReport>()
                .Include(x => x.RootCauses)
                .Include(x => x.Corrections)
                .Include(x => x.CorrectiveActions)
                .AsSplitQuery()
                .FirstOrDefaultAsync(x => x.AuditReportId == auditReportId && x.IsNonconformity == isNonconformity && !x.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<Dictionary<long, List<string>>> GetServiceNamesAsync(IReadOnlyCollection<long> ncarIds, CancellationToken cancellationToken)
        {
            var result = new Dictionary<long, List<string>>();
            if (ncarIds == null || ncarIds.Count == 0) return result;
            var ids = ncarIds.Distinct().ToList();

            // Where each NCAR came from: its audit report's schedule, or its
            // checklist's schedule. The schedule knows the offices that were audited.
            var rows = await ReadOnlyDbContext.Set<NonconformingActionReport>()
                .AsNoTracking()
                .Where(n => ids.Contains(n.Id))
                .Select(n => new
                {
                    n.Id,
                    n.Office,
                    ReportScheduleId = n.AuditReport != null ? (int?)n.AuditReport.AuditScheduleId : null,
                    ChecklistScheduleId = n.AuditChecklist != null ? (int?)n.AuditChecklist.AuditScheduleId : null
                })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            // The office type that means "Service" (seeded as OfficeType 1).
            var serviceTypeId = await ReadOnlyDbContext.Set<OfficeType>()
                .AsNoTracking()
                .Where(t => !t.IsDeleted && t.Name.ToLower() == "service")
                .Select(t => (int?)t.Id)
                .FirstOrDefaultAsync(cancellationToken)
                .ConfigureAwait(false) ?? 1;

            // Every office (deleted ones too, they can still be somebody's parent).
            var offices = await ReadOnlyDbContext.Set<Office>()
                .IgnoreQueryFilters()
                .AsNoTracking()
                .Select(o => new { o.Id, o.Name, o.OfficeTypeId, o.ParentOfficeId, o.IsDeleted })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
            var officeById = offices.ToDictionary(o => o.Id);

            // The Service of an office is the nearest office at or above it whose
            // type is Service. A Service that has since been deleted is skipped,
            // so its offices count under whatever it was moved under.
            string? ServiceOf(int officeId)
            {
                var seen = new HashSet<int>();
                int? id = officeId;
                while (id.HasValue && seen.Add(id.Value) && officeById.TryGetValue(id.Value, out var office))
                {
                    if (office.OfficeTypeId == serviceTypeId && !office.IsDeleted)
                        return office.Name;
                    id = office.ParentOfficeId;
                }
                return null; // no Service above it (or a loop in the data)
            }

            var scheduleIds = rows
                .SelectMany(r => new[] { r.ReportScheduleId, r.ChecklistScheduleId })
                .Where(i => i.HasValue)
                .Select(i => i!.Value)
                .Distinct()
                .ToList();

            var officesBySchedule = (await ReadOnlyDbContext.Set<AuditableOffices>()
                    .AsNoTracking()
                    .Where(a => !a.IsDeleted && scheduleIds.Contains(a.AuditScheduleId))
                    .Select(a => new { a.AuditScheduleId, a.OfficeId })
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false))
                .GroupBy(a => a.AuditScheduleId)
                .ToDictionary(g => g.Key, g => g.Select(x => x.OfficeId).Distinct().ToList());

            var officeIdsByName = offices
                .Where(o => !o.IsDeleted && !string.IsNullOrWhiteSpace(o.Name))
                .GroupBy(o => o.Name.Trim(), StringComparer.OrdinalIgnoreCase)
                .ToDictionary(g => g.Key, g => g.Select(o => o.Id).ToList(), StringComparer.OrdinalIgnoreCase);

            foreach (var row in rows)
            {
                var scheduleId = row.ReportScheduleId ?? row.ChecklistScheduleId;
                var officeIds = scheduleId.HasValue && officesBySchedule.TryGetValue(scheduleId.Value, out var found)
                    ? found
                    : new List<int>();

                // An NCAR with no schedule behind it (entered by hand): go by the
                // office name it carries ("A, B" when several offices were audited).
                if (officeIds.Count == 0 && !string.IsNullOrWhiteSpace(row.Office))
                {
                    var wanted = new List<string> { row.Office.Trim() };
                    wanted.AddRange(row.Office.Split(", ", StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries));
                    foreach (var name in wanted.Distinct(StringComparer.OrdinalIgnoreCase))
                        if (officeIdsByName.TryGetValue(name, out var byName))
                            officeIds.AddRange(byName);
                }

                result[row.Id] = officeIds
                    .Select(ServiceOf)
                    .Where(n => !string.IsNullOrWhiteSpace(n))
                    .Select(n => n!.Trim())
                    .Distinct(StringComparer.OrdinalIgnoreCase)
                    .OrderBy(n => n, StringComparer.OrdinalIgnoreCase)
                    .ToList();
            }

            return result;
        }
    }
}
