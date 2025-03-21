using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.KraModule
{
    public class KeyResultAreaRepository : BaseRepository<KeyResultArea, int, ImisDbContext>, IKeyResultAreaRepository
    {       
        public KeyResultAreaRepository(ImisDbContext dbContext) : base(dbContext) { }
        public async Task<EntityPageList<KeyResultArea, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _dbContext.KeyResultArea
                .Where(k => !k.IsDeleted)
                .AsNoTracking();
          
            var employees = await EntityPageList<KeyResultArea, int>
             .CreateAsync(query, page, pageSize, cancellationToken)
             .ConfigureAwait(false);
            return employees;
        }   
        public async Task<IEnumerable<KeyResultArea>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken)
        {
            return await _dbContext.KeyResultArea
                .Where(a => EF.Functions.Like(a.Name, $"{name}%") && !a.IsDeleted)
                .Take(noOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<IEnumerable<KeyResultArea>> GetAll(CancellationToken cancellationToken)
        {
                return await _dbContext.KeyResultArea
               .Where(o => !o.IsDeleted)  
               .AsNoTracking()            
               .ToListAsync(cancellationToken)
               .ConfigureAwait(false);
        }      
        // Save or Update method
        public new async Task<KeyResultArea> SaveOrUpdateAsync(KeyResultArea kra, CancellationToken cancellationToken)
        {
            if (kra == null) throw new ArgumentNullException(nameof(kra));
            // Check if the entity already exists
            var existingKra = await _dbContext.KeyResultArea
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
                await _dbContext.KeyResultArea.AddAsync(kra, cancellationToken).ConfigureAwait(false);
            }
            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return kra;
        }        
    }
}
