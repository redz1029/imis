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

        // 💡 FIXED: Added AsSplitQuery() to bypass Cartesian product explosion on deep loads
        public override async Task<AuditProgramme?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditProgramme>()
                .AsSplitQuery()
                .Include(x => x.Objectives)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Preparer)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Approvals)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoAuditProcesses)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.ResponsiblePersons)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoAuditors)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoStandardAuditPlans)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.AuditPlanProcesses)
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
        }

        // 💡 FIXED: Added AsSplitQuery() here to handle intensive details fetches safely
        public async Task<AuditProgramme?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditProgramme>()
                .AsSplitQuery()
                .Include(x => x.Objectives)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Preparer)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Approvals)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoAuditProcesses)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.ResponsiblePersons)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoAuditors)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoStandardAuditPlans)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.AuditPlanProcesses)
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditProgramme?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await GetDbContext().Set<AuditProgramme>()
                .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
        }

        // 💡 FIXED: Added AsSplitQuery() to prevent row duplication crashes during full list queries
        public async Task<IEnumerable<AuditProgramme>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .AsSplitQuery()
                .Include(x => x.Objectives)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Preparer)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Approvals)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoAuditProcesses)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.ResponsiblePersons)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoAuditors)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoStandardAuditPlans)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.AuditPlanProcesses)
                .Where(x => !x.IsDeleted)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        // 💡 FIXED: Added AsSplitQuery() to protect paginated list requests
        public async Task<EntityPageList<AuditProgramme, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _entities.AsNoTracking()
                .AsSplitQuery()
                .Include(x => x.Objectives)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Preparer)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Approvals)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoAuditProcesses)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.ResponsiblePersons)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoAuditors)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.IsoStandardAuditPlans)
                .Include(x => x.AuditPlans)
                    .ThenInclude(p => p.Entries)
                        .ThenInclude(e => e.AuditPlanProcesses)
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