using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditProgrammeModule
{
    public class AuditProgrammeRepository : BaseRepository<AuditProgramme, int, ImisDbContext, User>, IAuditProgrammeRepository
    {
        public AuditProgrammeRepository(ImisDbContext dbContext) : base(dbContext) { }

        /// <summary>
        /// Full detail graph for one programme — status, its transition
        /// history, its approval decisions, objectives, and every nested
        /// plan/entry/office/team relationship.
        /// </summary>
        public async Task<AuditProgramme?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditProgramme>()
                .AsSplitQuery() // Prevent Cartesian explosion on multi-level includes
                .Include(ap => ap.AuditStatus)
                .Include(ap => ap.StatusHistory.OrderBy(h => h.ChangedDate))
                    .ThenInclude(h => h.AuditStatus)
                .Include(ap => ap.Approvals.Where(a => !a.IsDeleted))
                    .ThenInclude(a => a.Approver)
                .Include(ap => ap.Objectives.Where(o => !o.IsDeleted))
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.AuditPlanProcesses.Where(app => !app.IsDeleted))
                            .ThenInclude(app => app.Office)
                                .ThenInclude(o => o.OfficeType)
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.AuditPlanProcesses.Where(app => !app.IsDeleted))
                            .ThenInclude(app => app.Office)
                                .ThenInclude(o => o.ParentOffice)
                                    .ThenInclude(po => po.OfficeType)
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.IsoAuditProcesses.Where(iap => !iap.IsDeleted))
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.IsoStandardAuditPlans.Where(isap => !isap.IsDeleted))
                            .ThenInclude(isap => isap.IsoStandard)
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.IsoAuditors.Where(ia => !ia.IsDeleted))
                            .ThenInclude(ia => ia.Team)
                // Continue past Team into its AuditorTeams roster (and
                // each roster row's Auditor) — this is what lets a printed
                // row or the "Generate from Team" picker show real names
                // instead of stopping at "Team 1".
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.IsoAuditors.Where(ia => !ia.IsDeleted))
                            .ThenInclude(ia => ia.Team!)
                                .ThenInclude(t => t.AuditorTeams.Where(at => !at.IsDeleted && at.IsActive))
                                    .ThenInclude(at => at.Auditor)
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.IsoAuditors.Where(ia => !ia.IsDeleted))
                            .ThenInclude(ia => ia.IsoAuditors) // Points to Auditor user/entity instead of self-referencing IsoAuditors
                .FirstOrDefaultAsync(ap => ap.Id == id && !ap.IsDeleted, cancellationToken);
        }

        public async Task<AuditProgramme?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await GetByIdAsync(id, cancellationToken);
        }

        public async Task<AuditProgramme?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditProgramme>()
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
        }

        /// <summary>
        /// Retrieves all Audit Programmes along with their full child entity
        /// graph. StatusHistory/Approvals are a detail-view concern, not
        /// needed for a list — Status + Objectives only here.
        /// </summary>
        public async Task<IEnumerable<AuditProgramme>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .AsSplitQuery()
                .Where(x => !x.IsDeleted)
                .Include(ap => ap.AuditStatus)
                .Include(ap => ap.Objectives.Where(o => !o.IsDeleted))
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.AuditPlanProcesses.Where(app => !app.IsDeleted))
                            .ThenInclude(app => app.Office)
                                .ThenInclude(o => o.OfficeType)
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.AuditPlanProcesses.Where(app => !app.IsDeleted))
                            .ThenInclude(app => app.Office)
                                .ThenInclude(o => o.ParentOffice)
                                    .ThenInclude(po => po.OfficeType)
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.IsoAuditProcesses.Where(iap => !iap.IsDeleted))
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.IsoStandardAuditPlans.Where(isap => !isap.IsDeleted))
                            .ThenInclude(isap => isap.IsoStandard)
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.IsoAuditors.Where(ia => !ia.IsDeleted))
                            .ThenInclude(ia => ia.Team)
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.IsoAuditors.Where(ia => !ia.IsDeleted))
                            .ThenInclude(ia => ia.Team!)
                                .ThenInclude(t => t.AuditorTeams.Where(at => !at.IsDeleted && at.IsActive))
                                    .ThenInclude(at => at.Auditor)
                .Include(ap => ap.AuditPlans.Where(p => !p.IsDeleted))
                    .ThenInclude(p => p.Entries.Where(e => !e.IsDeleted))
                        .ThenInclude(e => e.IsoAuditors.Where(ia => !ia.IsDeleted))
                            .ThenInclude((IsoAuditor ia) => ia.IsoAuditors)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        /// <summary>
        /// Optimized: Paginated views are lightweight. Heavy sub-collections
        /// are stripped out to ensure fast database execution and
        /// predictable memory footprint.
        /// </summary>
        public async Task<EntityPageList<AuditProgramme, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities.AsNoTracking()
                .Include(x => x.AuditStatus)
                .Include(x => x.Objectives.Where(o => !o.IsDeleted))
                .Where(x => !x.IsDeleted);

            return await EntityPageList<AuditProgramme, int>
                .CreateAsync(query, page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<List<int>> GetExistingObjectiveIdsAsync(int auditProgrammeId, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditProgrammeObjective>()
                .Where(x => x.AuditProgrammeId == auditProgrammeId && !x.IsDeleted)
                .Select(x => x.Id)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task AddObjectivesAsync(List<AuditProgrammeObjective> objectives, CancellationToken cancellationToken)
        {
            var context = GetDbContext();
            await context.Set<AuditProgrammeObjective>().AddRangeAsync(objectives, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);
        }

        public void RemoveObjectives(List<AuditProgrammeObjective> objectives)
        {
            if (objectives == null || !objectives.Any()) return;
            var context = GetDbContext();
            context.Set<AuditProgrammeObjective>().RemoveRange(objectives);
        }
    }
}