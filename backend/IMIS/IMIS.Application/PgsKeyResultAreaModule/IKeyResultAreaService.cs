using Base.Abstractions;

namespace IMIS.Application.PgsKraModule
{
    public interface IKeyResultAreaService : IService
    {
        Task<List<KeyResultAreaDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<KeyResultAreaDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<KeyResultAreaDto> SaveOrUpdateAsync(KeyResultAreaDto KraDto, CancellationToken cancellationToken);
    }   
}
