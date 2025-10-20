using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AnnouncementModule
{
    public interface IAnnouncementRepository : IRepository<Announcement, int>
    {
        Task<IEnumerable<Announcement>?> GetAllActive(CancellationToken cancellationToken);
        Task<Announcement?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<IEnumerable<Announcement>?> GetAll(CancellationToken cancellationToken);
        Task<IEnumerable<Announcement>?> FilteByName(string name, int noOfResults, CancellationToken cancellationToken);
        Task<EntityPageList<Announcement, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
