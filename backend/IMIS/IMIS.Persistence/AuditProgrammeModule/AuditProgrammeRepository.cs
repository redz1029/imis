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
        /// Retrieves a shallow or moderately loaded aggregate root for business logic operations.
        /// </summary>
        public override async Task<AuditProgramme?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditProgramme>()
                .Include(x => x.Objectives.Where(o => !o.IsDeleted))
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
        }

        /// <summary>
        /// Safely fetches the complete execution graph using a Split Query to prevent Cartesian explosion.
        /// Use this specifically when editing the entire tree or viewing deep details.
        /// </summary>
        /// <summary>
        /// Safely fetches the complete execution graph using a Split Query to prevent Cartesian explosion.
        /// Use this specifically when editing the entire tree or viewing deep details.
        /// </summary>
        public async Task<AuditProgramme?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditProgramme>()
                .AsSplitQuery() // Prevent Cartesian explosion on multi-level includes
                .Include(ap => ap.Objectives)
                .Include(ap => ap.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.AuditPlanProcesses)
                            .ThenInclude(app => app.Office)
                                .ThenInclude(o => o.OfficeType) // Load the office type (Service, Department, etc.)
                .Include(ap => ap.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.AuditPlanProcesses)
                            .ThenInclude(app => app.Office)
                                .ThenInclude(o => o.ParentOffice) // Load parent office
                                    .ThenInclude(po => po.OfficeType) // Load parent office type
                .Include(ap => ap.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoAuditProcesses)
                .Include(ap => ap.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoStandardAuditPlans)
                            .ThenInclude(isap => isap.IsoStandard)
                .Include(ap => ap.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoAuditors)
                            .ThenInclude(ia => ia.Team)
                .Include(ap => ap.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoAuditors)
                            // Explicitly type-cast the lambda parameter to break the naming conflict loop
                            .ThenInclude((IsoAuditor ia) => ia.IsoAuditors)
                .FirstOrDefaultAsync(ap => ap.Id == id, cancellationToken);
        }

        public async Task<AuditProgramme?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditProgramme>()
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
        }

        /// <summary>
        /// Optimized: Lists do not require a deep 4-level child collection load. 
        /// Pulls only the immediate root data and objectives for fast lookup rendering.
        /// </summary>
        public async Task<IEnumerable<AuditProgramme>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.Objectives.Where(o => !o.IsDeleted))
                .Where(x => !x.IsDeleted)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        /// <summary>
        /// Optimized: Paginated views are lightweight. Heavy sub-collections are stripped out 
        /// to ensure fast database execution and predictable memory footprint.
        /// </summary>
        public async Task<EntityPageList<AuditProgramme, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities.AsNoTracking()
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