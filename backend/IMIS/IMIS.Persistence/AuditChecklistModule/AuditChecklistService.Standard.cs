using IMIS.Application.AuditChecklistModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditChecklistModule
{
    /// <summary>
    /// The Audit Standard (Settings -> Audit Standard, e.g. "ISO 9001:2015") is
    /// what the checklist form prints as its AUDIT SCOPE. It is read from the
    /// standard the audit plan's clauses belong to; with no clause to tell it
    /// by, the active standard(s) stand in.
    /// </summary>
    public partial class AuditChecklistService
    {
        /// <summary>The audit standard name of each plan entry, by entry id.</summary>
        private async Task<Dictionary<int, string?>> GetAuditStandardNamesAsync(
            IEnumerable<int> entryIds, CancellationToken cancellationToken)
        {
            var ids = entryIds.Distinct().ToList();
            var result = ids.ToDictionary(id => id, _ => (string?)null);
            if (ids.Count == 0) return result;

            var pairs = await (
                    from sp in _dbContext.Set<IsoStandardAuditPlan>().AsNoTracking()
                    join s in _dbContext.Set<IsoStandard>() on sp.IsoStandardId equals (long?)s.Id
                    join v in _dbContext.Set<StandardVersion>() on s.VersionID equals v.Id
                    where !sp.IsDeleted && sp.AuditPlanEntryId != null && ids.Contains(sp.AuditPlanEntryId.Value)
                    select new { EntryId = sp.AuditPlanEntryId!.Value, v.Id, v.VersionName })
                .Distinct()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            foreach (var g in pairs.GroupBy(p => p.EntryId))
            {
                var names = g.OrderBy(p => p.Id)
                    .Select(p => p.VersionName?.Trim())
                    .Where(n => !string.IsNullOrWhiteSpace(n))
                    .Distinct()
                    .ToList();
                if (names.Count > 0) result[g.Key] = string.Join(", ", names);
            }

            if (result.Values.Any(v => v == null))
            {
                var active = (await _dbContext.Set<StandardVersion>()
                        .AsNoTracking()
                        .Where(v => v.isActive)
                        .OrderBy(v => v.Id)
                        .Select(v => v.VersionName)
                        .ToListAsync(cancellationToken)
                        .ConfigureAwait(false))
                    .Where(n => !string.IsNullOrWhiteSpace(n))
                    .Select(n => n.Trim())
                    .ToList();
                var fallback = active.Count == 0 ? null : string.Join(", ", active);
                foreach (var id in ids.Where(id => result[id] == null).ToList())
                    result[id] = fallback;
            }

            return result;
        }

        /// <summary>Puts the audit standard in the AUDIT SCOPE of the checklist rows.</summary>
        private async Task ApplyAuditStandardAsync(
            IReadOnlyCollection<AuditChecklistDto> rows, CancellationToken cancellationToken)
        {
            if (rows.Count == 0) return;

            var names = await GetAuditStandardNamesAsync(
                rows.Select(r => r.AuditPlanEntryId), cancellationToken).ConfigureAwait(false);
            foreach (var row in rows)
                row.AuditScope = names.TryGetValue(row.AuditPlanEntryId, out var name) ? name : null;
        }
    }
}
