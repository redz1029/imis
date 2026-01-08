using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.CharacterModule
{
    public interface ICharacterRepository : IRepository<Character, long>
    {
        Task<IEnumerable<Character>> GetAll(CancellationToken cancellationToken);
        Task<IEnumerable<Character>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);
        Task<EntityPageList<Character, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<Character?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
