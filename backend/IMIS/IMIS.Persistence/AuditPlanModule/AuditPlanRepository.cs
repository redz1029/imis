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
        public async Task<AuditPlan?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditPlan>()
                .Include(x => x.Preparer)
                .Include(x => x.Entries)
                .Include(x => x.Approvals)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<AuditPlan?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditPlan>()
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
            return await ReadOnlyDbContext.Set<AuditPlan>()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<AuditPlan>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
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
            return await _entities
                .Where(x => x.Id == auditPlanId)
                .SelectMany(x => x.Entries.Select(e => e.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task<List<int>> GetExistingAuditPlanApprovalIdsAsync(int auditPlanId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Id == auditPlanId)
                .SelectMany(x => x.Approvals.Select(a => a.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task AddAuditPlanEntriesAsync(List<AuditPlanEntry> entries, CancellationToken cancellationToken)
        {
            var context = GetDbContext();
            await context.Set<AuditPlanEntry>().AddRangeAsync(entries, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);
        }

        public async Task AddAuditPlanApprovalsAsync(List<AuditPlanApproval> approvals, CancellationToken cancellationToken)
        {
            var context = GetDbContext();
            await context.Set<AuditPlanApproval>().AddRangeAsync(approvals, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);
        }
    }
}