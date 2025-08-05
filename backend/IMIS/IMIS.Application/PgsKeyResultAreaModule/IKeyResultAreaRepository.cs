using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsKeyResultAreaModule;
using IMIS.Domain;

namespace IMIS.Application.PgsKraModule
{
    public interface IKeyResultAreaRepository : IRepository<KeyResultArea, int>
    {
        Task<EntityPageList<KeyResultArea, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<KeyResultArea>> GetAll(CancellationToken cancellationToken);
        new  Task<KeyResultArea> SaveOrUpdateAsync(KeyResultArea keyResultArea, CancellationToken cancellationToken);
        Task<IEnumerable<KeyResultArea>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);
        Task<IEnumerable<KeyResultArea>> GetAllFilteredAsync(KeyResultAreaFilter filter, CancellationToken cancellationToken);

    }   
}
