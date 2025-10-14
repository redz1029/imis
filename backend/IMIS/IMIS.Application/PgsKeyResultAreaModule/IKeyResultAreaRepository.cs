using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PgsKraModule
{
    public interface IKeyResultAreaRepository : IRepository<KeyResultArea, int>
    {
        Task<EntityPageList<KeyResultArea, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<KeyResultArea>> GetAll(CancellationToken cancellationToken);      
        Task<IEnumerable<KeyResultArea>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);
        Task<KeyResultArea?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }   
}
