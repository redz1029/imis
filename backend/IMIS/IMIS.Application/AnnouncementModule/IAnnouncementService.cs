using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AnnouncementModule
{
    public interface IAnnouncementService : IService
    {
        Task<List<AnnouncementDto>?> GetAllActive(CancellationToken cancellationToken);
        Task<AnnouncementDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<List<AnnouncementDto>?> GetAll(CancellationToken cancellationToken);
        Task<List<AnnouncementDto>?> FilteByName(string name, int noOfResults, CancellationToken cancellationToken);
        public Task<DtoPageList<AnnouncementDto, Announcement, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
