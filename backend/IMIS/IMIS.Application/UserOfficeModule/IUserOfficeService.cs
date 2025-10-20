using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.AnnouncementModule;
using IMIS.Domain;

namespace IMIS.Application.UserOfficeModule
{
    public interface IUserOfficeService : IService
    {
        public Task<DtoPageList<UserOfficeDto, UserOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<UserOfficeDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<UserOfficeDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<List<UserOfficeDto>?> FilteByName(string name, int noOfResults, CancellationToken cancellationToken);
    }
}
