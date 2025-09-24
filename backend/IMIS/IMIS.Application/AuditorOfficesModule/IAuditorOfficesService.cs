using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditorOfficesModule
{
    public interface IAuditorOfficesService : IService
    {
        Task<List<AuditorOfficesDto>?> GetAll(CancellationToken cancellationToken);
        Task<AuditorOfficesDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        public Task<DtoPageList<AuditorOfficesDto, AuditorOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
