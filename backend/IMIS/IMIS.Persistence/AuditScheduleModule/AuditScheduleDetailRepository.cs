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
    public class AuditScheduleDetailsRepository(ImisDbContext dbContext)
        : BaseRepository<AuditScheduleDetails, int, ImisDbContext, User>(dbContext), IAuditScheduleDetailsRepository
    {
        public async Task<EntityPageList<AuditScheduleDetails, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditScheduleDetails, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditScheduleDetails?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            // Accessing via ReadOnlyDbContext for efficiency during the check phase as per architectural pattern
            return await ReadOnlyDbContext.Set<AuditScheduleDetails>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<AuditScheduleDetails>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<AuditScheduleDetails?> GetWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.AuditSchedule)
                .Include(x => x.AuditPlanEntry)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Filtered Query Implementations ---

        public async Task<IEnumerable<AuditScheduleDetails>> FilterByAuditScheduleId(int auditScheduleId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.AuditScheduleId == auditScheduleId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<AuditScheduleDetails>> FilterByAuditPlanEntryId(int auditPlanEntryId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.AuditPlanEntryId == auditPlanEntryId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}