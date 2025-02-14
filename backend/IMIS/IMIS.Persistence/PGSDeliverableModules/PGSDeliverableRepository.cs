using Base.Abstractions;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PGSModules
{   
    public class PGSDeliverableRepository(ImisDbContext dbContext)
        : BaseRepository<PgsDeliverable, long, ImisDbContext>(dbContext), IPGSDeliverableRepository
    {
        public new async Task<PgsDeliverable> SaveOrUpdateAsync(PgsDeliverable pgs, CancellationToken cancellationToken)
        {
            if (pgs == null) throw new ArgumentNullException(nameof(pgs));          
            var existingPgs = await _dbContext.Deliverable
                .FirstOrDefaultAsync(d => d.Id == pgs.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingPgs != null)
            {               
                _dbContext.Entry(existingPgs).CurrentValues.SetValues(pgs);
            }
            else
            {             
                await _dbContext.Deliverable.AddAsync(pgs, cancellationToken).ConfigureAwait(false);
            }         
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return pgs;
        }
    }
}

