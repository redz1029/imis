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
            return await EntityPageList<KeyResultArea, int>
             .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
             .ConfigureAwait(false);
        }

        public async Task<IEnumerable<KeyResultArea>?> FilterByName(string name, int keyResultAreaNoOfResults, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(a => EF.Functions.Like(a.Name, $"{name}%"))
                .Take(keyResultAreaNoOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<KeyResultArea>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
               .AsNoTracking()            
               .ToListAsync(cancellationToken)
               .ConfigureAwait(false);
        }                   
    }
}
