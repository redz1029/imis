using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditScheduleModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditScheduleModule
{
    public class AuditScheduleRepository : BaseRepository<AuditSchedule, int, ImisDbContext, User>, IAuditScheduleRepository
    {
        public AuditScheduleRepository(ImisDbContext dbContext) : base(dbContext) { }

        // --- Main entity retrieval ---
        public async Task<AuditSchedule?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditSchedule>()
                .Include(x => x.AuditorTeams)
                .Include(x => x.AuditableOffices)
                .Include(x => x.AuditSchduleDetails)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<AuditSchedule?> GetByIdWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            // Note: If AuditableOffices or AuditSchduleDetails had deeper nested children, 
            // you would add .ThenInclude() here similar to the AuditPlan pattern.
            return await ReadOnlyDbContext.Set<AuditSchedule>()
                .Include(x => x.AuditorTeams)
                .Include(x => x.AuditableOffices)
                .Include(x => x.AuditSchduleDetails)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<AuditSchedule?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<AuditSchedule>()
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<AuditSchedule>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .Include(x => x.AuditorTeams)
                .Include(x => x.AuditableOffices)
                .Include(x => x.AuditSchduleDetails)
                .ToListAsync(cancellationToken);
        }

        public async Task<EntityPageList<AuditSchedule, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditSchedule, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Child helpers ---
        public async Task<List<int>> GetExistingAuditableOfficeIdsAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Id == auditScheduleId)
                .SelectMany(x => x.AuditableOffices.Select(o => o.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task<List<int>> GetExistingAuditScheduleDetailsIdsAsync(int auditScheduleId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(x => x.Id == auditScheduleId)
                .SelectMany(x => x.AuditSchduleDetails.Select(d => d.Id))
                .ToListAsync(cancellationToken);
        }

        public async Task AddAuditableOfficesAsync(List<AuditableOffices> offices, CancellationToken cancellationToken)
        {
            var context = GetDbContext();
            await context.Set<AuditableOffices>().AddRangeAsync(offices, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);
        }

        public async Task AddAuditScheduleDetailsAsync(List<AuditScheduleDetails> details, CancellationToken cancellationToken)
        {
            var context = GetDbContext();
            await context.Set<AuditScheduleDetails>().AddRangeAsync(details, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);
        }
    }
}