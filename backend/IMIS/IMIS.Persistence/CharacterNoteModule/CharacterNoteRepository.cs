using Base.Abstractions;
using IMIS.Application.CharacterModule;
using IMIS.Domain;

namespace IMIS.Persistence.CharacterNoteModule
{
    public class CharacterNoteRepository : BaseRepository<CharacterNote, long, ImisDbContext>, ICharacterNoteRepository
    {
        public CharacterNoteRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
    }
}
