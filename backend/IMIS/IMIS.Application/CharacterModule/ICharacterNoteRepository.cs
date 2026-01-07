using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.CharacterModule
{
    public interface ICharacterNoteRepository : IRepository<CharacterNote, long>
    {
    }
}
