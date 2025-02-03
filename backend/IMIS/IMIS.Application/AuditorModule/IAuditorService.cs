using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.AuditorModule
{
    public interface IAuditorService : IService
    {
        Task<List<AuditorDto>> GetAll(CancellationToken cancellationToken);
        Task<AuditorDto> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<AuditorDto>> FilteByName(string name, int noOfResults, CancellationToken cancellationToken);
    }
}
