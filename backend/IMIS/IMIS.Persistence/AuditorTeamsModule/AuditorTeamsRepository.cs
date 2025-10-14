using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AuditorTeamsModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
 
namespace IMIS.Persistence.AuditorTeamsModule
{   
    public class AuditorTeamsRepository : BaseRepository<AuditorTeams, int, ImisDbContext>, IAuditorTeamsRepository
    {
    
        public AuditorTeamsRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<EntityPageList<AuditorTeams, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<AuditorTeams, int>.CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken).ConfigureAwait(false);
        }       
        public async Task<List<AuditorTeams>> GetByTeamIdAsync(long teamId, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(p => p.TeamId == teamId)
                .Include(x => x.Auditor)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<IEnumerable<AuditorTeams>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _entities
            .Where(a => a.IsActive && a.Auditor != null)
            .Include(x => x.Auditor)
            .ToListAsync(cancellationToken);
        }  
    }
}
