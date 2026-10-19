using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.ImprovementTypeModule
{
    public interface IImprovementTypeRepository : IRepository<ImprovementType, int>
    {
        Task<IEnumerable<ImprovementType>?> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<ImprovementType, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
