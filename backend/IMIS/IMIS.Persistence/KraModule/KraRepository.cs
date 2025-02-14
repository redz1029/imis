using Base.Abstractions;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraModule
{
    public class KraRepository : BaseRepository<Kra, int, ImisDbContext>, IKraRepository
    {
        // Constructor
        public KraRepository(ImisDbContext dbContext) : base(dbContext) { }
        public async Task<IEnumerable<Kra>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.Kra
            .Where(o => !o.IsDeleted)  // Filter out deleted records
            .AsNoTracking()            // Optimizes for read-only queries
            .ToListAsync(cancellationToken)  // Executes asynchronously
            .ConfigureAwait(false); 
        }        
        // Save or Update method
        public new async Task<Kra> SaveOrUpdateAsync(Kra kra, CancellationToken cancellationToken)
        {
            if (kra == null) throw new ArgumentNullException(nameof(kra));

            // Check if the entity already exists
            var existingKra = await _dbContext.Kra
                .FirstOrDefaultAsync(d => d.Id == kra.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingKra != null)
            {
                // Update existing entity
                _dbContext.Entry(existingKra).CurrentValues.SetValues(kra);
            }
            else
            {
                // Add new entity
                await _dbContext.Kra.AddAsync(kra, cancellationToken).ConfigureAwait(false);
            }
            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return kra;
        }        
    }
}
