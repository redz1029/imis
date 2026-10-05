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

        // Live approval chain (with each signatory's user and template) — the plan's
        // status is derived from these rows, so every read that builds an
        // AuditPlanDto must load them.
        private static IQueryable<AuditPlan> WithSignatories(IQueryable<AuditPlan> query) => query
            .Include(x => x.IQASignatories.Where(s => !s.IsDeleted))
                .ThenInclude(s => s.Signatory)
            .Include(x => x.IQASignatories.Where(s => !s.IsDeleted))
                .ThenInclude(s => s.IQASignatoryTemplate)
            .Include(x => x.ApprovalHistories.Where(h => !h.IsDeleted))
                .ThenInclude(h => h.User)
            .Include(x => x.AuditSchedules.Where(s => !s.IsDeleted))
                .ThenInclude(s => s.IQASignatories.Where(sig => !sig.IsDeleted))
                    .ThenInclude(sig => sig.Signatory)
            .Include(x => x.AuditSchedules.Where(s => !s.IsDeleted))
                .ThenInclude(s => s.ApprovalHistories.Where(h => !h.IsDeleted))
                    .ThenInclude(h => h.User)
            .Include(x => x.AuditSchedules.Where(s => !s.IsDeleted))
                .ThenInclude(s => s.AuditableOffices!.Where(ao => !ao.IsDeleted))
                    .ThenInclude(ao => ao.Office);

        public override async Task<AuditPlan?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            return await WithSignatories(GetDbContext().Set<AuditPlan>().AsSplitQuery())
                .Include(x => x.Preparer)
                .Include(x => x.Entries)
                .Include(x => x.AuditSchedules)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<AuditPlan?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await WithSignatories(GetDbContext().Set<AuditPlan>().AsSplitQuery())
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
                        .ThenInclude(app => app.Office)
                            .ThenInclude(o => o!.ParentOffice)
                .Include(x => x.AuditSchedules)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<AuditPlan?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditPlan>()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<AuditPlan>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await WithSignatories(_entities.AsNoTracking().AsSplitQuery())
                .Include(x => x.Preparer)
                .Include(x => x.Entries)
                .Include(x => x.AuditSchedules)
                .ToListAsync(cancellationToken);
        }

        public async Task<EntityPageList<AuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditPlan, int>
                .CreateAsync(
                    WithSignatories(_entities.AsNoTracking()),
                    page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<List<int>> GetExistingAuditPlanEntryIdsAsync(int auditPlanId, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditPlanEntry>()
                .Where(x => x.AuditPlanId == auditPlanId)
                .Select(x => x.Id)
                .ToListAsync(cancellationToken);
        }

        public async Task AddAuditPlanEntriesAsync(List<AuditPlanEntry> entries, CancellationToken cancellationToken)
        {
            var context = GetDbContext();
            await context.Set<AuditPlanEntry>().AddRangeAsync(entries, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);
        }

        public void RemoveAuditPlanEntries(List<AuditPlanEntry> entries)
        {
            if (entries == null || !entries.Any()) return;
            GetDbContext().Set<AuditPlanEntry>().RemoveRange(entries);
        }
    }
}