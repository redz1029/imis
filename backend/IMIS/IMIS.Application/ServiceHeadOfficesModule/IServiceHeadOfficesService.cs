using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.ServiceHeadOfficesModule
{
    public interface IServiceHeadOfficesService : IService
    {
        Task<List<ServiceHeadOfficesDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<ServiceHeadOfficesDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<ServiceHeadOfficesDto, ServiceHeadOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
