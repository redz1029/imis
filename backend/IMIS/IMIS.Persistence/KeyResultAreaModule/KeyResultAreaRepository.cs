using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsKeyResultAreaModule;
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
          
            var keyResultArea = await EntityPageList<KeyResultArea, int>
             .CreateAsync(query, page, pageSize, cancellationToken)
             .ConfigureAwait(false);
            return keyResultArea;
        }   
        public async Task<IEnumerable<KeyResultArea>?> FilterByName(string name, int keyResultAreaNoOfResults, CancellationToken cancellationToken)
        {
            return await _dbContext.KeyResultArea
                .Where(a => EF.Functions.Like(a.Name, $"{name}%") && !a.IsDeleted)
                .Take(keyResultAreaNoOfResults)
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

      
        public async Task<IEnumerable<KeyResultArea>> GetAllFilteredAsync(KeyResultAreaFilter filter, CancellationToken cancellationToken)
        {
            var query = _dbContext.KeyResultArea.AsQueryable();

            if (filter.IsDeleted.HasValue)
            {
                query = query.Where(x => x.IsDeleted == filter.IsDeleted.Value);
            }

            return await query
                .AsNoTracking()
                .ToListAsync(cancellationToken);
        }

        // Save or Update method
        public new async Task<KeyResultArea> SaveOrUpdateAsync(KeyResultArea keyResultArea, CancellationToken cancellationToken)
        {
            if (keyResultArea == null) throw new ArgumentNullException(nameof(keyResultArea));
            // Check if the entity already exists
            var existingKeyResultArea = await _dbContext.KeyResultArea
                .FirstOrDefaultAsync(d => d.Id == keyResultArea.Id, cancellationToken)
                .ConfigureAwait(false);
            if (existingKeyResultArea != null)
            {
                // Update existing entity
                _dbContext.Entry(existingKeyResultArea).CurrentValues.SetValues(keyResultArea);
            }
            else
            {
                // Add new entity
                await _dbContext.KeyResultArea.AddAsync(keyResultArea, cancellationToken).ConfigureAwait(false);
            }
            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return keyResultArea;
        }        
    }
}
