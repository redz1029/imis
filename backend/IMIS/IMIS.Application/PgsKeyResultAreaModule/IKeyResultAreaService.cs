using Base.Abstractions;
using IMIS.Application.OfficeModule;

namespace IMIS.Application.PgsKraModule
{
    public interface IKeyResultAreaService : IService
    {
        Task<List<KeyResultAreaDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<KeyResultAreaDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<KeyResultAreaDto> SaveOrUpdateAsync(KeyResultAreaDto KraDto, CancellationToken cancellationToken);
        Task<List<KeyResultAreaDto>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);
    }   
}
