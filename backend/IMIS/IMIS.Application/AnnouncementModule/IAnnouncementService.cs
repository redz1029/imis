using Base.Abstractions;

namespace IMIS.Application.AnnouncementModule
{
    public interface IAnnouncementService : IService
    {
        Task<List<AnnouncementDto>?> GetAllActive(CancellationToken cancellationToken);
        Task<AnnouncementDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<List<AnnouncementDto>?> GetAll(CancellationToken cancellationToken);
    }
}
