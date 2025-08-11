using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.UserOfficeModule
{
    public interface IUserOfficeRepository : IRepository<UserOffices, int>
    {
        Task<EntityPageList<UserOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);     
        Task<IEnumerable<UserOffices>> GetAll(CancellationToken cancellationToken);       
    }
}
