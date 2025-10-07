using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.AuditorModule
{
    public interface IAuditorService : IService
    {
        public Task<DtoPageList<AuditorDto, Auditor, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<AuditorDto>?> GetAll(CancellationToken cancellationToken);
        Task<AuditorDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<AuditorDto>?> FilteByName(string name, int noOfResults, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
