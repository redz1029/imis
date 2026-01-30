using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.TeamModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.TeamModule
{
    public class TeamRepository(ImisDbContext dbContext) : BaseRepository<Team, int, ImisDbContext, User>(dbContext), ITeamRepository
    {
        public async Task<EntityPageList<Team, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {          
            return await EntityPageList<Team, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);            
        }
        public async Task<Team?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            return await ReadOnlyDbContext.Set<Team>()
                .FirstOrDefaultAsync(d => d.Id == id, cancellationToken);
        }
        public async Task<IEnumerable<Team>?> FilterByName(string name, int teamNoOfResults, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(a => EF.Functions.Like(a.Name, $"{name}%"))
                .Take(teamNoOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);            
        }
        public async Task<IEnumerable<Team>> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            return await _entities
                .Include(t => t.AuditorTeams)
                .Where(t => !t.IsActive)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<IEnumerable<Team>> GetAllAsync(CancellationToken cancellationToken)
        {           
            return await _entities                 
                 .AsNoTracking()
                 .ToListAsync(cancellationToken)
                 .ConfigureAwait(false);
        }      
    }
}
