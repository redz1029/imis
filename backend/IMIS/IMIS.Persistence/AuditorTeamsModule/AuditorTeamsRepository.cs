using IMIS.Application.AuditorTeamsModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditorTeamsModule
{
    public class AuditorTeamsRepository : IAuditorTeamsRepository
    {
        private readonly ImisDbContext _dbContext; 

        public AuditorTeamsRepository(ImisDbContext dbContext)
        {
            _dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
        }

        public async Task<IEnumerable<AuditorTeams>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _dbContext.AuditorTeams
                .Where(a => a.IsActive && a.Auditor != null) // Only active teams with valid auditors
                .Include(x => x.Auditor) // Ensure Auditor is included
                .ToListAsync(cancellationToken);
        }
        public async Task<AuditorTeams> SaveOrUpdateAsync(AuditorTeams auditorTeam, CancellationToken cancellationToken)
        {
            if (auditorTeam == null) throw new ArgumentNullException(nameof(auditorTeam));

            // Attempt to find the existing entity by its composite key
            var existingAuditorTeam = await _dbContext.AuditorTeams
                .FirstOrDefaultAsync(at => at.TeamId == auditorTeam.TeamId && at.AuditorId == auditorTeam.AuditorId, cancellationToken)
                .ConfigureAwait(false);

            if (existingAuditorTeam != null)
            {
                // Remove the existing entity
                _dbContext.AuditorTeams.Remove(existingAuditorTeam);
                await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            }

            // Add the new entity
            await _dbContext.AuditorTeams.AddAsync(auditorTeam, cancellationToken).ConfigureAwait(false);
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return auditorTeam;
        }
    }
}
