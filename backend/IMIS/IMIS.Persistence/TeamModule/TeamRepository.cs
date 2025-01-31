using Base.Abstractions;
using IMIS.Application.TeamModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.TeamModule
{
    public class TeamRepository(ImisDbContext dbContext) : BaseRepository<Team, int, ImisDbContext>(dbContext), ITeamRepository
    {
        public async Task<IEnumerable<Team>> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            return await _dbContext.Teams
                .Where(t => !t.IsDeleted)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<Team>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _dbContext.Teams.Where(t => t.IsActive && !t.IsDeleted).ToListAsync(cancellationToken).ConfigureAwait(false);
        }
    }
}
