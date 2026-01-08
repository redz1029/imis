using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Application.CharacterModule
{
    public interface ICharacterService : IService
    {
        Task<List<CharacterDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<CharacterDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<CharacterDto>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);
        public Task<DtoPageList<CharacterDto, Character, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
