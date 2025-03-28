using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.TeamModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.TeamModule
{
    public class TeamRepository(ImisDbContext dbContext) : BaseRepository<Team, int, ImisDbContext>(dbContext), ITeamRepository
    {
        public async Task<EntityPageList<Team, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _dbContext.Teams
                .Where(k => !k.IsDeleted)
                .AsNoTracking();

            var team = await EntityPageList<Team, int>
             .CreateAsync(query, page, pageSize, cancellationToken)
             .ConfigureAwait(false);
            return team;
        }

        public async Task<IEnumerable<Team>> FilterByName(string name, int noOfResults, CancellationToken cancellationToken)
        {
            return await _dbContext.Teams
                .Where(a => EF.Functions.Like(a.Name, $"{name}%") && !a.IsDeleted)
                .Take(noOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<IEnumerable<Team>> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            return await _dbContext.Teams
                .Include(t => t.AuditorTeams)
                .Where(t => !t.IsActive)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<IEnumerable<Team>> GetAllAsync(CancellationToken cancellationToken)
        {           
            return await _dbContext.Teams
                 .Where(o => !o.IsDeleted)
                 .AsNoTracking()
                 .ToListAsync(cancellationToken)
                 .ConfigureAwait(false);
        }

        public new async Task<Team> SaveOrUpdateAsync(Team team, CancellationToken cancellationToken)
        {
            if (team == null) throw new ArgumentNullException(nameof(team));
            // Check if the entity already exists
            var existingTeam = await _dbContext.Teams
                .FirstOrDefaultAsync(d => d.Id == team.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingTeam != null)
            {
                // Update existing entity
                _dbContext.Entry(existingTeam).CurrentValues.SetValues(team);
            }
            else
            {
                // Add new entity
                await _dbContext.Teams.AddAsync(team, cancellationToken).ConfigureAwait(false);
            }
            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return team;
        }
    }
}
