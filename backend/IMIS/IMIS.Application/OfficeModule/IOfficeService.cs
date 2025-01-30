using Base.Abstractions;

namespace IMIS.Application.OfficeModule
{
    public interface IOfficeService : IService
    {
        Task<List<OfficeDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<OfficeDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
    }
}
