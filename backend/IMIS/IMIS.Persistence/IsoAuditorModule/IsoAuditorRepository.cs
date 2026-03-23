using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.IsoAuditorModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.IsoAuditorModule
{
    public class IsoAuditorRepository(ImisDbContext dbContext)
        : BaseRepository<IsoAuditor, int, ImisDbContext, User>(dbContext), IIsoAuditorRepository
    {
        public async Task<EntityPageList<IsoAuditor, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<IsoAuditor, int>
                .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IsoAuditor?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            // Accessing via ReadOnlyDbContext for efficiency during the check phase
            return await ReadOnlyDbContext.Set<IsoAuditor>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<IsoAuditor>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IsoAuditor?> GetWithDetailsAsync(int id, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Include(x => x.Team)
                .Include(x => x.IsoAuditors)
                .Include(x => x.AuditPlanEntry)
                .FirstOrDefaultAsync(x => x.Id == id, cancellationToken)
                .ConfigureAwait(false);
        }

        // --- Filtered Query Implementations ---

        public async Task<IEnumerable<IsoAuditor>> FilterByTeamId(int teamId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.TeamId == teamId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<IsoAuditor>> FilterByUserId(string userId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.AuditorId == userId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<IsoAuditor>> FilterByAuditPlanEntryId(int entryId, CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .Where(x => x.AuditPlanEntryId == entryId)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
    }
}