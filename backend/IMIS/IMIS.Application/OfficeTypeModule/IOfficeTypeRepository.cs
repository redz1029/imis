using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.OfficeTypeModule
{
    public interface IOfficeTypeRepository : IRepository<OfficeType, int>
    {
        Task<IEnumerable<OfficeType>?> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<OfficeType, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
