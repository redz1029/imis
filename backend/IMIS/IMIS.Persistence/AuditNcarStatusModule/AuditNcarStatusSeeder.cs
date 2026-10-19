using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditNcarStatusModule
{
    /// <summary>
    /// Guarantees the AuditNcarStatus lookup always contains the two canonical
    /// rows the Summary of Findings dropdown and the NCAR flow depend on:
    /// "NC" (Nonconformity) and "OFI" (Opportunity for Improvement).
    /// Idempotent: existing rows are matched by name and never duplicated, so it
    /// is safe to run on every startup and alongside the HasData migration seed.
    /// </summary>
    public static class AuditNcarStatusSeeder
    {
        private static readonly string[] _requiredStatuses = { "NC", "OFI" };

        public static async Task SeedAsync(ImisDbContext dbContext, CancellationToken cancellationToken = default)
        {
            var existing = await dbContext.Set<AuditNcarStatus>()
                .Select(x => x.ncarStatus)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            var missing = _requiredStatuses
                .Where(name => !existing.Any(e => string.Equals(e?.Trim(), name, StringComparison.OrdinalIgnoreCase)))
                .Select(name => new AuditNcarStatus { Id = 0, ncarStatus = name, IsDeleted = false })
                .ToList();

            if (missing.Count == 0) return;

            dbContext.Set<AuditNcarStatus>().AddRange(missing);
            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
        }
    }
}
