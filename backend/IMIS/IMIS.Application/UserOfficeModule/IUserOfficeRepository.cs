using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.UserOfficeModule
{
    public interface IUserOfficeRepository : IRepository<UserOffices, int>
    {
        Task<EntityPageList<UserOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);     
        Task<IEnumerable<UserOffices>> GetAll(CancellationToken cancellationToken);
        Task<List<UserOffices>> GetByOfficeIdAsync(int officeId, CancellationToken cancellationToken);
        Task<UserOffices?> GetOfficeHeadAsync(int officeId, CancellationToken cancellationToken);
        Task<bool> IsUserOfficeHeadAsync(string userId, int officeId, CancellationToken cancellationToken);
        Task<UserOffices?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<UserOffices>?> FilteByName(string name, int noOfResults, CancellationToken cancellationToken);
    }
}
