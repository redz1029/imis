using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.CharacterModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.CharacterModule
{
    public class CharacterRepository : BaseRepository<Character, long, ImisDbContext>, ICharacterRepository
    {
        public CharacterRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<IEnumerable<Character>> GetAll(CancellationToken cancellationToken)
        {
            return await _entities
               .AsNoTracking()
               .ToListAsync(cancellationToken)
               .ConfigureAwait(false);

        }

        public async Task<IEnumerable<Character>?> FilterByName(string name, int keyResultAreaNoOfResults, CancellationToken cancellationToken)
        {
            return await _entities
                .Where(a => EF.Functions.Like(a.Name, $"{name}%"))
                .Take(keyResultAreaNoOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public async Task<EntityPageList<Character, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            return await EntityPageList<Character, long>
             .CreateAsync(_entities.AsNoTracking(), page, pageSize, cancellationToken)
             .ConfigureAwait(false);
        }
    }
}
