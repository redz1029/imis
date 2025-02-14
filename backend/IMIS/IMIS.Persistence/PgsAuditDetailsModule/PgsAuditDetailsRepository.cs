using Base.Abstractions;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsModule
{
    public class PgsAuditDetailsRepository(ImisDbContext dbContext)
   : BaseRepository<PgsAuditDetails, long, ImisDbContext>(dbContext), IPgsAuditDetailsRepository
    {
        public new async Task<PgsAuditDetails> SaveOrUpdateAsync(PgsAuditDetails pgs, CancellationToken cancellationToken)
        {
            if (pgs == null) throw new ArgumentNullException(nameof(pgs));
            var existingPgs = await _dbContext.PgsProjectStatus
                .FirstOrDefaultAsync(d => d.Id == pgs.Id, cancellationToken)
            .ConfigureAwait(false);
            if (existingPgs != null)
            {
                _dbContext.Entry(existingPgs).CurrentValues.SetValues(pgs);
            }
            else
            {
                await _dbContext.PgsProjectStatus.AddAsync(pgs, cancellationToken).ConfigureAwait(false);
            }
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return pgs;
        }
    }
}
