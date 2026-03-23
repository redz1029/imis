using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.IsoAuditorModule
{
    public interface IIsoAuditorService : IService
    {
        Task<List<IsoAuditorDto>?> GetAll(CancellationToken cancellationToken);

        Task<IsoAuditorDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        Task<DtoPageList<IsoAuditorDto, IsoAuditor, int>> GetPaginatedAsync(
            int page,
            int pageSize,
            CancellationToken cancellationToken);

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}