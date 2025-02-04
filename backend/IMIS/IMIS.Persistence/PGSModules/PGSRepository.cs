
using Base.Abstractions;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PGSModules
{
   
    public class PGSRepository(ImisDbContext dbContext)
        : BaseRepository<PGS, int, ImisDbContext>(dbContext), IPGSRepository
    {
       
        public async Task<IEnumerable<PGS>> GetAllAsync(CancellationToken cancellationToken)
        {
            return await _dbContext.PGS
                .Where(pgs => !pgs.IsDeleted)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
      
        public async Task<IEnumerable<PGS>> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            return await _dbContext.PGS
                .Where(pgs => !pgs.IsDeleted) 
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<PGS> CreateAsync(PGS pgs, CancellationToken cancellationToken)
        {
            if (pgs == null) throw new ArgumentNullException(nameof(pgs));

      
            await _dbContext.PGS.AddAsync(pgs, cancellationToken).ConfigureAwait(false);
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return pgs;
        }

    }
}

