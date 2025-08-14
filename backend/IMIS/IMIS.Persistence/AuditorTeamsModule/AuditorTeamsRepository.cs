using Base.Abstractions;
using IMIS.Application.AuditorTeamsModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditorTeamsModule
{   
    public class AuditorTeamsRepository : BaseRepository<AuditorTeams, int, ImisDbContext>, IAuditorTeamsRepository
    {
        //    [Obsolete("Do not inject Database Context here, inherit the BaseRepository and make use of _entities and ReadOnlyDbContext intead.", true)]
        //    private readonly ImisDbContext _dbContext; 

        public AuditorTeamsRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<IEnumerable<AuditorTeams>> GetAllAsyncFilterByTeamId(long? teamId, CancellationToken cancellationToken)
        {
            return await _entities
            .Where(p => teamId == null || p.TeamId == teamId)
            .Include(x => x.Auditor)
            .ToListAsync(cancellationToken);
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
