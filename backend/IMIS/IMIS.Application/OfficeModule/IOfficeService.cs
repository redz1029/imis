using Base.Abstractions;
using IMIS.Application.AuditorModule;

namespace IMIS.Application.OfficeModule
{
    public interface IOfficeService : IService
    {
        Task<List<OfficeDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<OfficeDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
       

    }
}
