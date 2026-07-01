using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.StandardVersionModule
{
    public interface IStandardVersionService : IService
    {
        Task<List<StandardVersionDto>?> GetAll(CancellationToken cancellationToken);

        Task<StandardVersionDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        Task<DtoPageList<StandardVersionDto, StandardVersion, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}