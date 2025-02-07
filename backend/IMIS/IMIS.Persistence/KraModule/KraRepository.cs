using Base.Abstractions;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraModule
{
   
    public class KraRepository(ImisDbContext dbContext)
    : BaseRepository<Kra, int, ImisDbContext>(dbContext), IKraRepository
    {

        public new async Task<Kra> SaveOrUpdateAsync(Kra kra, CancellationToken cancellationToken)
        {
            if (kra == null) throw new ArgumentNullException(nameof(kra));


            var existingKra = await _dbContext.Kra
                .FirstOrDefaultAsync(d => d.Id == kra.Id, cancellationToken)
            .ConfigureAwait(false);

            if (existingKra != null)
            {

                _dbContext.Entry(existingKra).CurrentValues.SetValues(kra);
            }
            else
            {

                await _dbContext.Kra.AddAsync(kra,cancellationToken).ConfigureAwait(false);
            }

            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return kra;
        }


    }
}

