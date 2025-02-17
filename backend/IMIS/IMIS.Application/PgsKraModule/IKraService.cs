using Base.Abstractions;

namespace IMIS.Application.PgsKraModule
{
    public interface IKraService : IService
    {
        Task<List<KraDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<KraDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<KraDto> SaveOrUpdateAsync(KraDto KraDto, CancellationToken cancellationToken);
    }   
}
