using Base.Abstractions;
using Base.Primitives;
using IMIS.Application.PgsKraModule;

namespace IMIS.Application.CharacterModule
{
    public interface ICharacterService : IService
    {
        Task<List<CharacterDto>?> GetAllAsync(CancellationToken cancellationToken);
    }
}
