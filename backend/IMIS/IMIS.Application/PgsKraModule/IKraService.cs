
using Base.Abstractions;


namespace IMIS.Application.PgsKraModule
{
    public interface IKraService : IService
    {
        Task<KraDto> SaveOrUpdateAsync(KraDto KraDto, CancellationToken cancellationToken);
        
    }


   
}
