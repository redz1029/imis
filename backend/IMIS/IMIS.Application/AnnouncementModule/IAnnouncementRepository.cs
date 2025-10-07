using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.AnnouncementModule
{
    public interface IAnnouncementRepository : IRepository<Announcement, int>
    {
        Task<IEnumerable<Announcement>?> GetAllActive(CancellationToken cancellationToken);
        Task<Announcement?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
