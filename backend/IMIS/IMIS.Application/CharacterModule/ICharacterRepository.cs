using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.CharacterModule
{
    public interface ICharacterRepository : IRepository<Character, long>
    {
        Task<IEnumerable<Character>> GetAll(CancellationToken cancellationToken);
    }
}
