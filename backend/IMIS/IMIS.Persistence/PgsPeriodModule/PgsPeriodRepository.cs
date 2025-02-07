using Base.Abstractions;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PgsPeriodModule
{



    public class PgsPeriodRepository(ImisDbContext dbContext)
  : BaseRepository<PgsPeriod, int, ImisDbContext>(dbContext), IPgsPeriodRepository
    {

        public new async Task<PgsPeriod> SaveOrUpdateAsync(PgsPeriod PgsPeriod, CancellationToken cancellationToken)
        {
            if (PgsPeriod == null) throw new ArgumentNullException(nameof(PgsPeriod));

            var existingPgsPeriod = await _dbContext.PgsPeriod
                .FirstOrDefaultAsync(d => d.Id == PgsPeriod.Id, cancellationToken)
            .ConfigureAwait(false);

            if (existingPgsPeriod != null)
            {
                _dbContext.Entry(existingPgsPeriod).CurrentValues.SetValues(existingPgsPeriod);
            }
            else
            {

                await _dbContext.PgsPeriod.AddAsync(PgsPeriod, cancellationToken).ConfigureAwait(false);
            }

            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            return PgsPeriod;
        }

    }
}
