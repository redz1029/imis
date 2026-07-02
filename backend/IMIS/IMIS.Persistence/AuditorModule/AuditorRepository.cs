using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditorModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditorModule
{
    public class AuditorRepository(ImisDbContext dbContext) : BaseRepository<Auditor, int, ImisDbContext, User>(dbContext), IAuditorRepository
    {
        public async Task<EntityPageList<Auditor, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<Auditor, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);           
        }
        public async Task<Auditor?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<Auditor>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<IEnumerable<Auditor>?> FilteByName(string name, int auditorNoOfResults, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(a => EF.Functions.Like(a.Name, $"{name}%"))
                .Take(auditorNoOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<IEnumerable<Auditor>?> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
     
        public async Task<Team?> GetTeamByUserIdAsync(string userId, CancellationToken cancellationToken)
        {
            var auditor = await ReadOnlyDbContext.Set<Auditor>()
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.UserId == userId && x.IsActive, cancellationToken);

            if (auditor == null)
            {
                return null;
            }

            var auditorTeam = await ReadOnlyDbContext.Set<AuditorTeams>()
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.AuditorId == auditor.Id && x.IsActive, cancellationToken);

            if (auditorTeam == null)
            {
                return null;
            }

            return await ReadOnlyDbContext.Set<Team>()
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.Id == auditorTeam.TeamId && x.IsActive, cancellationToken);
        }
    }
}
