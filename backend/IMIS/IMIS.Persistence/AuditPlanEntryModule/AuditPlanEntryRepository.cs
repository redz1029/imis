using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditPlanEntryModule
{
    public class AuditPlanEntryRepository : BaseRepository<AuditPlanEntry, int, ImisDbContext, User>, IAuditPlanEntryRepository
    {
        public AuditPlanEntryRepository(ImisDbContext dbContext) : base(dbContext)
        {
            
        }

        // --- Helper for navigation data ---
        // Note: Using 'ResposiblePersons' to match the property name in your Domain Entity
        private IQueryable<AuditPlanEntry> FullEntry => _entities
            .Include(x => x.AuditPlan)
            .Include(x => x.Office)
            .Include(x => x.Team)
            .Include(x => x.Auditors)
            .Include(x => x.IsoStandards)
            .Include(x => x.AuditPlanProcesses)
            .Include(x => x.ResposiblePersons);

        // --- Core Queries ---

        public async Task<IEnumerable<AuditPlanEntry>> GetAll(CancellationToken cancellationToken)
        {
            return await FullEntry
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<EntityPageList<AuditPlanEntry, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = FullEntry
                .AsNoTracking()
                .OrderBy(x => x.DayNumber)
                .ThenBy(x => x.Time);

            return await EntityPageList<AuditPlanEntry, int>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
        }

        public async Task<AuditPlanEntry?> GetWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await FullEntry
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Filtered Queries ---

        public async Task<IEnumerable<AuditPlanEntry>> FilterByAuditPlanId(int auditPlanId, CancellationToken cancellationToken)
        {
            return await FullEntry
                .Where(x => x.AuditPlanId == auditPlanId)
                .OrderBy(x => x.DayNumber)
                .ThenBy(x => x.Time)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanEntry>> FilterByDayNumber(int auditPlanId, int dayNumber, CancellationToken cancellationToken)
        {
            return await FullEntry
                .Where(x => x.AuditPlanId == auditPlanId && x.DayNumber == dayNumber)
                .OrderBy(x => x.Time)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanEntry>> FilterByOfficeId(int officeId, CancellationToken cancellationToken)
        {
            return await FullEntry
                .Where(x => x.OfficeId == officeId)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanEntry>> FilterByTeamId(int teamId, CancellationToken cancellationToken)
        {
            // Assuming Team is a navigation property; filtering by the FK or ID
            return await FullEntry
                .Where(x => x.Team != null && x.Team.Id == teamId)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanEntry>> FilterByAuditorId(string auditorId, CancellationToken cancellationToken)
        {
            return await FullEntry
                .Where(x => x.Auditors.Any(a => a.Id == auditorId))
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanEntry>> FilterByProcessId(int processId, CancellationToken cancellationToken)
        {
            return await FullEntry
                .Where(x => x.AuditPlanProcesses.Any(p => p.Id == processId))
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanEntry>> FilterByResponsiblePersonId(int personId, CancellationToken cancellationToken)
        {
            return await FullEntry
                .Where(x => x.ResposiblePersons.Any(r => r.Id == personId))
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditPlanEntry>> FilterByIsoStandardId(int standardId, CancellationToken cancellationToken)
        {
            return await FullEntry
                .Where(x => x.IsoStandards.Any(s => s.Id == standardId))
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Infrastructure ---

        public async Task<AuditPlanEntry?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            // Matches the IsoStandardRepository pattern using ReadOnlyDbContext
            return await ReadOnlyDbContext.Set<AuditPlanEntry>()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }
    }
}