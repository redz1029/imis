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

        /// <summary>True when ISO clauses still belong to this standard.</summary>
        Task<bool> IsInUseAsync(int id, CancellationToken cancellationToken);

        /// <summary>True when another standard already has this name.</summary>
        Task<bool> NameExistsAsync(string name, int exceptId, CancellationToken cancellationToken);
    }
}