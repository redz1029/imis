using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditPlanModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditPlanModule
{
    public class AuditPlanRepository : BaseRepository<AuditPlan, int, ImisDbContext, User>, IAuditPlanRepository
    {
        public AuditPlanRepository(ImisDbContext dbContext) : base(dbContext) { }

        // --- Main entity retrieval ---
        public override async Task<AuditPlan?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            // Fix: Replaced ReadOnlyDbContext with GetDbContext() to ensure EF monitors changes for updates
            return await GetDbContext().Set<AuditPlan>()
                .Include(x => x.Preparer)
                .Include(x => x.Entries)
                .Include(x => x.Approvals)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<AuditPlan?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            // Fix: Replaced ReadOnlyDbContext with GetDbContext() to properly map deep child nested graphs
            return await GetDbContext().Set<AuditPlan>()
                .Include(x => x.Preparer)
                .Include(x => x.Entries)
                    .ThenInclude(e => e.IsoAuditors)
                .Include(x => x.Entries)
                    .ThenInclude(e => e.ResponsiblePersons)
                .Include(x => x.Entries)
                    .ThenInclude(e => e.IsoAuditProcesses)
                .Include(x => x.Entries)
                    .ThenInclude(e => e.IsoStandardAuditPlans)
                .Include(x => x.Entries)
                    .ThenInclude(e => e.AuditPlanProcesses)
                .Include(x => x.Approvals)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<AuditPlan?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            // Fix: Using the write context to ensure status flag tracking changes are persisted seamlessly
            return await GetDbContext().Set<AuditPlan>()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<AuditPlan>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking() // Safe for read-only bulk list screens
                .Include(x => x.Preparer)
                .Include(x => x.Entries)
                .Include(x => x.Approvals)
                .ToListAsync(cancellationToken);
        }

        public async Task<EntityPageList<AuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditPlan, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Child helpers ---
        public async Task<List<int>> GetExistingAuditPlanEntryIdsAsync(int auditPlanId, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditPlanEntry>()
                .Where(x => x.AuditPlanId == auditPlanId)
                .Select(x => x.Id)
                .ToListAsync(cancellationToken);
        }

        public async Task<List<int>> GetExistingAuditPlanApprovalIdsAsync(int auditPlanId, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditPlanApproval>()
                .Where(x => x.AuditPlanId == auditPlanId)
                .Select(x => x.Id)
                .ToListAsync(cancellationToken);
        }

        public async Task AddAuditPlanEntriesAsync(List<AuditPlanEntry> entries, CancellationToken cancellationToken)
        {
            var context = GetDbContext();
            await context.Set<AuditPlanEntry>().AddRangeAsync(entries, cancellationToken);
            // Note: SaveChangesAsync is usually dropped here if handled globally by your Service/UnitOfWork layer, 
            // but keeping it explicit matching your old codebase framework structure.
            await context.SaveChangesAsync(cancellationToken);
        }

        public async Task AddAuditPlanApprovalsAsync(List<AuditPlanApproval> approvals, CancellationToken cancellationToken)
        {
            var context = GetDbContext();
            await context.Set<AuditPlanApproval>().AddRangeAsync(approvals, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);
        }

        // Fix: Added explicit collection removal syncing helpers to clear orphan nodes on application updates
        public void RemoveAuditPlanEntries(List<AuditPlanEntry> entries)
        {
            if (entries == null || !entries.Any()) return;
            var context = GetDbContext();
            context.Set<AuditPlanEntry>().RemoveRange(entries);
        }

        public void RemoveAuditPlanApprovals(List<AuditPlanApproval> approvals)
        {
            if (approvals == null || !approvals.Any()) return;
            var context = GetDbContext();
            context.Set<AuditPlanApproval>().RemoveRange(approvals);
        }
    }
}