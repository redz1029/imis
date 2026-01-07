using Base.Abstractions;
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
    }
}
